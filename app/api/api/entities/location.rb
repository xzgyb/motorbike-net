module Api::Entities
  class Location < Grape::Entity
    expose :longitude, :latitude

    root "locations", "location"
  end
end
