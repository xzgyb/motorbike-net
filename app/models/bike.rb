class Bike
  include Mongoid::Document

  field :name, type: String, default: ''
  field :module_id, type: String
  field :longitude, type: Float, default: 0
  field :latitude, type: Float, default: 0
  field :battery, type: Float, default: 0
  field :travel_mileage, type: Float, default: 0
  field :diag_info, type: Hash, default: {}

  validates :module_id, presence:true, uniqueness: true

  embedded_in :user
  has_many :locations
end
