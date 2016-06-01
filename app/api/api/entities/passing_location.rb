module Api::Entities
  class PassingLocation < Grape::Entity
    expose :longitude, :latitude
  end
end
