module Api::Entities
  class ActionVideoAttachment < Grape::Entity
    expose(:url)          { |instance, _| instance.file.url }
    expose(:thumb_url)    { |instance, _| instance.file.url(:thumb) }
    expose(:_id, as: :id) { |instance, _| instance._id.to_s } 
  end

  class Living < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose(:_id, as: :id) { |instance, _| instance._id.to_s } 

    expose :title, :place, :price, :coordinates
    expose :content, if: lambda { |_, options| options[:export_content] == true }

    with_options(format_with: :time) { expose :updated_at }
  
    expose :videos, using: ActionVideoAttachment

    root "livings", "living"
  end
end
