class Comment < ApplicationRecord
  belongs_to :living
  belongs_to :user
  belongs_to :reply_to_user, class_name: 'User', foreign_key: 'reply_to_user_id'
end
