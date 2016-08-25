module Api::Entities
  class OrderTaker < Grape::Entity
    expose(:avatar_url)   { |user, _| user.avatar.url }
    expose(:name)         { |user, _| user.name }
  end
end
