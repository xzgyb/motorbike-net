require 'api/entities/action_image_attachment'

module Api::Entities
  class TakeAlongSomething < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose(:_id, as: :id) { |instance, _| instance._id.to_s } 
    expose(:user_id)      { |instance, _| instance.user_id.to_s }

    expose :title, :place, :price, :longitude, :latitude, :distance
    expose :content, if: :export_content

    with_options(format_with: :time) do
      expose :updated_at, :start_at, :end_at
    end
  
    expose :images, using: ActionImageAttachment

    expose :sender, using: SomethingSender
    expose :receiver, using: SomethingReceiver

    root "take_along_somethings", "take_along_something"
  end
end
