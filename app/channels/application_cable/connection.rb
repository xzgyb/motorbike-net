# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Api::DoorkeeperTokenHelper

    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      self.current_user.update_attribute(:online, true)
    end

    def disconnect
      self.current_user.update_attribute(:online, false)
    end

    protected
      def find_verified_user
        reject_unauthorized_connection if doorkeeper_token.nil?

        current_user = User.where(id: doorkeeper_token.resource_owner_id).first
        reject_unauthorized_connection if current_user.nil?

        current_user
      end
  end
end
