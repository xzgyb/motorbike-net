module Api::Entities
  class SomethingSender < Grape::Entity
    expose :id, :name, :phone, :address
  end
end
