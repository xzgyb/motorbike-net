class FriendLocationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "friend_location:#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
