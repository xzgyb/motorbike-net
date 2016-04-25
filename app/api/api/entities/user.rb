module Api::Entities
  class User < Grape::Entity
    expose(:_id, as: :id) { |instance, _| instance._id.to_s }
    expose :name

    expose :name, :email, if: :export_detail

    root "users", "user"
  end
end