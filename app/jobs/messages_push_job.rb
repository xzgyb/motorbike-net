class MessagesPushJob < ActiveJob::Base
  queue_as :default

  def perform(user, unread_count)
    data = { unread_count: unread_count }
    ActionCable.server.broadcast("messages:#{user.id}",
                                 messages: data)
  end
end
