class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :bike

  field :longitude, type: Float, default: 0
  field :latitude, type: Float, default: 0
end
