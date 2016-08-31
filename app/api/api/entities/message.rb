require 'api/entities/friendship'
require 'api/entities/order_take'
require 'api/entities/participation'

module Api::Entities
  class Message < Grape::Entity
    FRIEND_IF_LAMBDA        = lambda { |obj, _| 
      obj.message_object.is_a?(::Friendship) 
    }

    PARTICIPATION_IF_LAMBDA = lambda { |obj, _| 
      obj.message_object.is_a?(::Participation)
    }

    ORDER_TAKE_IF_LAMBDA = lambda { |obj, _|
      obj.message_object.is_a?(::OrderTake)
    }

    expose(:is_read)      { |message, _| message.is_read? ? 1 : 0 }
    expose(:message_type) { |message, _| ::Message.type_code(message) }

    expose(:message_object, 
           as: :friendship, 
           using: Friendship, 
           if: FRIEND_IF_LAMBDA)
    
    expose(:participation, 
           using: Participation , 
           if: PARTICIPATION_IF_LAMBDA) do |message, _|
      message.message_object
    end

    expose(:order_take, 
           using: OrderTake, 
           if: ORDER_TAKE_IF_LAMBDA) do |message, _|
      message.message_object
    end


    root "messages", "message"
  end
end
