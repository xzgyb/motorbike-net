module Api::Entities
  class SomethingReceiver < Grape::Entity
    expose :id, :name, :phone, :address, :longitude, :latitude, :place
  end
end
