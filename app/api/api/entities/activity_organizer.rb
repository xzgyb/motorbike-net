module Api::Entities
  class ActivityOrganizer < Grape::Entity
    expose(:avatar_url)   { |user, _| user.avatar.url }
    expose(:name)         { |user, _| user.name }
    expose(:title)        { |user, _| "3级飞车党" }
    expose(:level)        { |user, _| "LV.3"    }
  end
end
