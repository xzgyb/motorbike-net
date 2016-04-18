module Api::Entities
  class ActionImageAttachment < Grape::Entity
    expose(:url)          { |instance, _| instance.file.url }
    expose(:thumb_url)    { |instance, _| instance.file.url(:thumb) }
    expose(:_id, as: :id) { |instance, _| instance._id.to_s } 
  end
end
