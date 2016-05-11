module Api
  module DoorkeeperTokenHelper
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
