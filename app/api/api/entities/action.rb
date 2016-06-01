require 'api/entities/action_image_attachment'
require 'api/entities/action_video_attachment'

module Api::Entities
  class Action < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose :id, :user_id

    expose(:type) { |instance, _| ::Action.categories[instance.category] }

    expose :title, :place, :price, :longitude, :latitude
    expose :content, if: :export_content

    with_options(format_with: :time) do
      expose :updated_at
      expose :start_at,
             :end_at, 
             if: lambda { |obj, _| obj.activity? || obj.take_along_something? }
    end
  
    expose :images, 
           using: ActionImageAttachment,
           if: lambda { |obj, _| obj.activity? || obj.take_along_something? }

    expose :videos,
           using: ActionVideoAttachment,
           if: lambda { |obj, _| obj.living? }

    root "actions", "action"
  end
end
