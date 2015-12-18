class Location
  include Mongoid::Document
  belongs_to :bike

  field :longitude, type: Float, default: 0
  field :latitude, type: Float, default: 0
end
