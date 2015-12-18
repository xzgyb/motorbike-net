module Api::Entities
  class Location < Grape::Entity

    expose :longitude
    expose :latitude

    root "locations", "location"
  end
end