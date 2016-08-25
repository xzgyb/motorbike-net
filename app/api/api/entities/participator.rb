module Api::Entities
  class Participator < Grape::Entity
    expose(:avatar_url)   { |user, _| user.avatar.url }
    expose(:name)         { |user, _| user.name }
  end
end
