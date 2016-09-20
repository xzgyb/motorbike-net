module Api::Entities
  class Like < Grape::Entity
    expose :id

    expose(:user_id)   { |like, _| like.user.id }
    expose(:user_name) { |like, _| like.user.name }

    root "likes", "like"
  end
end
