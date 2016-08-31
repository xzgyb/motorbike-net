class FriendLocationChannel < ApplicationCable::Channel
  def do_subscribed
    stream_from "friend_location:#{current_user.id}"
  end
end
