class Bike
  include Mongoid::Document
  embedded_in :user

  field :name, type: String, default: ''
  field :longitude, type: Float, default: 0
  field :latitude, type: Float, default: 0
  field :battery, type: Float, default: 0
  field :travel_mileage, type: Float, default: 0

end
