class ActionChannel < ApplicationCable::Channel
  def do_subscribed
    stream_from "action:#{current_user.id}"
  end
end
