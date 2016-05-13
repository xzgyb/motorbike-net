# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Api::DoorkeeperTokenHelper

    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      self.current_user.update_attribute(:online, true) if self.current_user
    end

    def disconnect
      self.current_user.update_attribute(:online, false) if self.current_user
    end

    protected
      def find_verified_user
        if doorkeeper_token && doorkeeper_token.accessible?
          User.where(id: doorkeeper_token.resource_owner_id).first
        else
          nil
        end
      end
  end
end
