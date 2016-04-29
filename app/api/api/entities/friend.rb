module Api::Entities
  class Friend < Grape::Entity
    expose(:_id, as: :id) { |instance, _| instance._id.to_s } 
    expose :name

    root "friends", "friend"
  end
end