# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def subscribed
      if current_user.nil?
        reject
        return
      end

      do_subscribed
    end

    def do_subscribed
    end
  end
end
