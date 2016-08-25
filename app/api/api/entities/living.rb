require 'api/entities/video_attachment'
require 'api/entities/image_attachment'

module Api::Entities
  class Living < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose :id, :user_id, :title, :place, :price, :longitude, :latitude, :distance
    expose :content, if: :export_content

    with_options(format_with: :time) { expose :updated_at }
  
    expose :videos, using: VideoAttachment
    expose :images, using: ImageAttachment

    root "livings", "living"
  end
end
