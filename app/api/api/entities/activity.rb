require 'api/entities/action_image_attachment'

module Api::Entities
  class Activity < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose :id, :user_id, :title, :place, :price, :longitude, :latitude, :distance
    expose :content, if: :export_content

    with_options(format_with: :time) do
      expose :updated_at, :start_at, :end_at
    end
  
    expose :images, using: ActionImageAttachment

    root "activities", "activity"
  end
end
