
module Api::Entities
  class ActionImageAttachment < Grape::Entity
    expose(:url)          { |instance, _| instance.file.url }
    expose(:thumb_url)    { |instance, _| instance.file.url(:thumb) }
    expose(:_id, as: :id) { |instance, _| instance._id.to_s } 
  end

  class TakeAlongSomething < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose(:_id, as: :id) { |instance, _| instance._id.to_s } 

    expose :title, :place, :price, :coordinates
    expose :content, if: lambda { |_, options| options[:export_content] == true }

    with_options(format_with: :time) do
      expose :updated_at, :start_at, :end_at
    end
  
    expose :images, using: ActionImageAttachment

    root "take_along_somethings", "take_along_something"
  end
end
