require 'api/entities/action_video_attachment'

module Api::Entities
  class Living < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose :id, :user_id, :title, :place, :price, :longitude, :latitude, :distance
    expose :content, if: :export_content

    with_options(format_with: :time) { expose :updated_at }
  
    expose :videos, using: ActionVideoAttachment

    root "livings", "living"
  end
end
