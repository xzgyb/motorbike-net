module Api::Entities
  class SomethingReceiver < Grape::Entity
    expose(:_id, as: :id) { |instance, _| instance._id.to_s } 
    expose :name, :phone, :address
  end
end
