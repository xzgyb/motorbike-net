# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Api::DoorkeeperTokenHelper

    identified_by :current_user

    def connect
      #self.current_user = find_verified_user
      self.current_user = User.first
    end

    protected
      def find_verified_user1
        reject_unauthorized_connection if doorkeeper_token.nil?

        current_user = User.where(id: doorkeeper_token.resource_owner_id).first
        reject_unauthorized_connection if current_user.nil?

        current_user
      end

      def find_verified_user
        if current_user = warden.authenticate(scope: :user)
          current_user
        else
          reject_unauthorized_connection
        end
      end

      def warden
        request.env['warden']
      end
  end
end
