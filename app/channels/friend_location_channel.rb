class FriendLocationChannel < ApplicationCable::Channel
  def subscribed
    if current_user.nil?
      reject
      return
    end

    stream_from "friend_location:#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
