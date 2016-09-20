module Api::Entities
  class Comment < Grape::Entity
    HAS_REPLY_USER = lambda do |obj, _| 
      obj.reply_to_user != nil
    end 
    
    expose :id

    expose(:user_id)   { |comment, _| comment.user.id }
    expose(:user_name) { |comment, _| comment.user.name }
    expose :content

    expose(:reply_to_user_id, if: HAS_REPLY_USER) { |comment, _| 
      comment.reply_to_user.id
    }

    expose(:reply_to_user_name, if: HAS_REPLY_USER) { |comment, _| 
      comment.reply_to_user.name
    }

    root "comments", "comment"
  end
end
