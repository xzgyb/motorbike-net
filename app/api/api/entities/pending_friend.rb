module Api::Entities
  class PendingFriend < Grape::Entity
    expose(:_id, as: :id) { |instance, _| instance._id.to_s } 
    expose :name

    root "pending_friends", "pending_friend"
  end
end
