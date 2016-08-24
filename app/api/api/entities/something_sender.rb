module Api::Entities
  class SomethingSender < Grape::Entity
    expose :id, :name, :phone, :address, :longitude, :latitude, :place
  end
end
