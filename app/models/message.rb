class Message < ApplicationRecord
  belongs_to :user
  belongs_to :message_object, polymorphic: true

  scope :latest, -> { order(created_at: :desc) }
  scope :unread, -> { where(is_read: false) }

  def self.type_code(message)
    case message.message_object 
    when Friendship then 0
    when Participation then 1
    when OrderTake then 2
    end
  end

  def self.mark_all_read_for(user)
    user.messages.unread.update_all(is_read: true)
  end

  def self.unread_count_for(user)
    user.messages.unread.count
  end

  after_create do |message|
    user = message.user
    MessagesPushJob.perform_later(user, Message.unread_count_for(user))
  end
end
