module Api::Entities
  class PendingFriend < Grape::Entity
    expose :id, :name

    root "pending_friends", "pending_friend"
  end
end
