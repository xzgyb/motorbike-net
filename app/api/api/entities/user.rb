module Api::Entities
  class User < Grape::Entity
    expose :id, :name, :phone, :email
    expose(:avatar_url)   { |instance, _| instance.avatar.url }
    root "users", "user"
  end
end
