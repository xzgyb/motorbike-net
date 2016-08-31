class MessagesChannel < ApplicationCable::Channel
  def do_subscribed
    stream_from "messages:#{current_user.id}"
  end
end
