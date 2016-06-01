module Api::Entities
  class ActionVideoAttachment < Grape::Entity
    expose(:url)          { |instance, _| instance.file.url }
    expose(:thumb_url)    { |instance, _| instance.file.url(:thumb) }
    expose :id
  end
end
