class Action < ApplicationRecord
  include GeoNearable
  include GlobalID::Identification

  enum category: [:activity, :living, :take_along_something]

  belongs_to :user

  has_many :images, class_name: "ActionImageAttachment"
  has_many :videos, class_name: "ActionVideoAttachment"

  has_one :sender
  has_one :receiver

  accepts_nested_attributes_for :images, :videos, :sender, :receiver, allow_destroy: true

  validates :title, :place, :longitude, :latitude, presence: true
  validates :start_at, :end_at, 
            presence: true, 
            if: -> (action) { action.activity? || action.take_along_something? }

  scope :latest, -> { order(updated_at: :desc) }

  scope :near, -> (longitude, latitude, max_distance = 1000) {
    where(%{
      ST_DWithin(
        ST_GeographyFromText(
          'SRID=4326;POINT(' || actions.longitude || ' ' || actions.latitude || ')'
        ),
        ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
        %d
      )
    } % [longitude, latitude, max_distance])
  }

  scope :circle_for, -> (user) {
    where(user_id: user.friend_ids + [user.id])
  }

  class << self
    def circle_actions_for(user)
      user_ids = user.friend_ids << user.id
      self.in(user_id: user_ids)
    end

    def nearby_actions(user, action_type, coordinates, opts = {})
      opts[:match] = mongodb_match_expression(user, action_type) 
      self.near(coordinates, opts)
    end

    private
      def mongodb_match_expression(user, action_type)
        user_ids = user.friend_ids << user.id

        and_expressions = [{"user_id" => {"$in" => user_ids}}] 
        and_expressions << {"_enumtype" => action_type} if action_type != :all

        {"$and" => and_expressions}
      end
  end
end
