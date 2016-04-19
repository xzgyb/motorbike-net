class Action
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

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

  accepts_nested_attributes_for :images, :videos, allow_destroy: true

  validates :title, :place, :coordinates, presence: true
  validates :images, :start_at, :end_at, presence: true, 
                     if: -> (action) { action.activity? || action.take_along_something? }
  validates :videos, presence: true, if: :living?

  validate do
    if self.coordinates.length != 2 
      errors.add(:coordinates, 'Must have two elements: [longitude, latitude]')
    end
  end

  scope :latest, -> { order_by(:updated_at => :desc) }

  before_save :normalize_coordinates

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
