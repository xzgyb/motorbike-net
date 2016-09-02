module Api::Entities
  class OrderTake < Grape::Entity
    expose(:id)
    expose(:user_id)           { |obj, _| obj.user.id }
    expose(:user_avatar_url)   { |obj, _| obj.user.avatar.url }
    expose(:user_name)         { |obj, _| obj.user.name }
    expose(:take_along_something_id) { |obj, _| obj.take_along_something.id }
  end
end
