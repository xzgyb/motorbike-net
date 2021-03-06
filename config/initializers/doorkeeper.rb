Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (needs plugins)
  orm :active_record

  resource_owner_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  resource_owner_from_credentials do |_routes; user|
    [:phone, :name, :email].find do |user_key|
      user = User.find_for_database_authentication(user_key => params[:username])
    end

    if user && (user.valid_oauth_login_code?(params[:password]) ||
                user.valid_password?(params[:password]))
      user
    end
  end

  admin_authenticator do
    unless current_user && current_user.admin?
      redirect_to  '/'
    end
  end

  enable_application_owner confirmation: true

  access_token_expires_in 24.hours
  use_refresh_token
  native_redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
  force_ssl_in_redirect_uri Rails.env.production?
  realm 'Meixing Tech'

  grant_flows %w[authorization_code client_credentials password]
end
