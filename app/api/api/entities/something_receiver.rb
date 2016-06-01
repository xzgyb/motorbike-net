module Api::Entities
  class SomethingReceiver < Grape::Entity
    expose :id, :name, :phone, :address
  end
end
