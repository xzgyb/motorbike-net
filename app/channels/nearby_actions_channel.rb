class NearbyActionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "nearby_actions:#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
