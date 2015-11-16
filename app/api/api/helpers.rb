module Api
  module Helpers
    def respond_ok(response = {})
      response.empty? ? {ok: 1}
                      : {ok: 1}.merge(response)
    end

    def current_user
      @current_user ||= User.where(id: doorkeeper_token.resource_owner_id).first if doorkeeper_token
    end

    private

    def doorkeeper_token
      @_doorkeeper_token ||= Doorkeeper::OAuth::Token.authenticate(
          decorated_request,
          *Doorkeeper.configuration.access_token_methods
      )
    end

    def decorated_request
      Doorkeeper::Grape::AuthorizationDecorator.new(request)
    end
  end
end