module Api::Entities
  class Friendship < Grape::Entity
    expose :friend_id

    expose(:friend_name)       { |friendship, _| friendship.friend.name       }
    expose(:friend_avatar_url) { |friendship, _| friendship.friend.avatar_url }
    expose(:accepted)          { |friendship, _| friendship.accepted? ? 1 : 0 }

    root "friendships", "friendship"
  end
end
