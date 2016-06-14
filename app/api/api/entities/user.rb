module Api::Entities
  class User < Grape::Entity
    expose :id, :name, :phone, :email

    expose(:title)          { |user| "3级飞车党" }
    expose(:level)          { |user| "LV.3"    }

    expose(:travel_mileage) { |user| 
      user.bikes.reduce(0) { |sum, bike| sum + bike.travel_mileage }.to_s
    }

    expose(:avatar_url)   { |user| user.avatar.url }
    root "users", "user"
  end
end
