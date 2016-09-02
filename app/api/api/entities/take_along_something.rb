require 'api/entities/image_attachment'
require 'api/entities/something_receiver'
require 'api/entities/something_sender'
require 'api/entities/order_take'

module Api::Entities
  class TakeAlongSomething < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose :id, :user_id, :title, :place, :price, :longitude, :latitude, :distance
    expose :content, if: :export_detail
    expose :order_take, using: OrderTake, if: :export_detail

    with_options(format_with: :time) do
      expose :updated_at, :start_at, :end_at
    end
  
    expose :images, using: ImageAttachment

    expose :sender, using: SomethingSender
    expose :receiver, using: SomethingReceiver

    root "take_along_somethings", "take_along_something"
  end
end
