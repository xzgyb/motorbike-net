require 'api/entities/action_video_attachment'

module Api::Entities
  class Living < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose(:_id, as: :id) { |instance, _| instance._id.to_s } 
    expose(:user_id)      { |instance, _| instance.user_id.to_s }

    expose :title, :place, :price, :longitude, :latitude, :distance
    expose :content, if: :export_content

    with_options(format_with: :time) { expose :updated_at }
  
    expose :videos, using: ActionVideoAttachment

    root "livings", "living"
  end
end
