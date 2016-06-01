module Api::Entities
  class Friend < Grape::Entity
    expose :id, :name, :avatar_url, :longitude, :latitude

    root "friends", "friend"
  end
end
