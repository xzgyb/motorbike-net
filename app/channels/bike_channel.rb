class BikeChannel < ApplicationCable::Channel
  def do_subscribed
    stream_from "bike:#{current_user.id}"
  end
end
