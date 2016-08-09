class Action < ApplicationRecord
  include GlobalID::Identification

  enum category: [:activity, :living, :take_along_something]

  belongs_to :user

  has_many :images, class_name: "ActionImageAttachment"
  has_many :videos, class_name: "ActionVideoAttachment"

  has_one :sender
  has_one :receiver
  has_one :event, dependent: :destroy

  accepts_nested_attributes_for :images, :videos, :sender, :receiver, allow_destroy: true

  validates :title, :place, :longitude, :latitude, presence: true
  validates :start_at, :end_at, 
            presence: true, 
            if: -> (action) { action.activity? || action.take_along_something? }

  scope :latest, -> { order(updated_at: :desc) }
  scope :by_distance, -> { order('distance') }

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

  scope :select_all_with_distance, -> (longitude, latitude) {
    if longitude.nil? || latitude.nil?
      select("*, 0 as distance")
    else
      select(%{*, 
        ST_Distance(
          ST_GeographyFromText(
            'SRID=4326;POINT(' || longitude || ' ' || latitude || ')'
          ),
          ST_GeographyFromText('SRID=4326;POINT(%f %f)')) as distance
      } % [longitude, latitude])
    end
  }

  scope :circle_for, -> (user) {
    where(user_id: user.friend_ids + [user.id])
  }

end
