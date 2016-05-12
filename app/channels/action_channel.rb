class ActionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "action:#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
