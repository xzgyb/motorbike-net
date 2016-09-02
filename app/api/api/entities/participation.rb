module Api::Entities
  class Participation < Grape::Entity
    expose(:id)
    expose(:user_id)           { |obj, _| obj.user.id }
    expose(:user_avatar_url)   { |obj, _| obj.user.avatar.url }
    expose(:user_name)         { |obj, _| obj.user.name }
    expose(:activity_id)       { |obj, _| obj.activity.id }
  end
end
