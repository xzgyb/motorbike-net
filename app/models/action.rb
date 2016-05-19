class Action
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum
  include GeoNearable
  include GlobalID::Identification

  enum :type, [:activity, :living, :take_along_something]
    
  field :title,      type: String
  field :place,      type: String
  field :start_at,   type: DateTime
  field :end_at,     type: DateTime
  field :content,    type: String, default: ''
  field :price,      type: BigDecimal, default: 0

  field :coordinates, type: Array, default: []
  index({coordinates: Mongo::Index::GEO2D}, {background: true})

  has_many :images, class_name: "ActionImageAttachment"
  has_many :videos, class_name: "ActionVideoAttachment"

  has_one :sender
  has_one :receiver

  belongs_to :user

  accepts_nested_attributes_for :images, :videos, :sender, :receiver, allow_destroy: true

  validates :title, :place, :coordinates, presence: true
  validates :start_at, :end_at, presence: true, 
                     if: -> (action) { action.activity? || action.take_along_something? }

  validate do
    if self.coordinates.length != 2 
      errors.add(:coordinates, 'Must have two elements: [longitude, latitude]')
    end
  end

  scope :latest, -> { order_by(:updated_at => :desc) }

  before_save :normalize_coordinates

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

  def longitude
    (self.coordinates.try(:first) || 0).to_f
  end

  def latitude
    (self.coordinates.try(:last) || 0).to_f
  end

  def longitude=(value)
    self.coordinates[0] = value 
  end

  def latitude=(value)
    self.coordinates[1] = value
  end

  private
    def normalize_coordinates
      self.coordinates = self.coordinates.map { |field| field.to_f } 
    end
end
