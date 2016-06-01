module Api::Entities
  class User < Grape::Entity
    expose :id, :name
    expose(:avatar_url)   { |instance, _| instance.avatar.url }
    expose :email, if: :export_detail

    root "users", "user"
  end
end
