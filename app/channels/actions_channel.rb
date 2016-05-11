class ActionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "actions:#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
