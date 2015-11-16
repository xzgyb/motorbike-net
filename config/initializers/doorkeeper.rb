Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (needs plugins)
  orm :mongoid4

  resource_owner_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  resource_owner_from_credentials do |_routes|
    u = User.find_for_database_authentication(phone: params[:username])
    u if u && u.valid_oauth_login_code?(params[:password])
  end

  enable_application_owner confirmation: true

  access_token_expires_in 24.hours
  use_refresh_token
  native_redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
  force_ssl_in_redirect_uri Rails.env.production?
  realm 'Meixing Tech'

end

Doorkeeper.configuration.token_grant_types << 'password'