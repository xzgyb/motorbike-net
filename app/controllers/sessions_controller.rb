class SessionsController < Devise::SessionsController
  # Change params value for support email, phone, name login.
  def create
    set_auth_key
    set_devise_authentication_keys
    super
  end

  private
    def set_auth_key
      user_params = warden.params[:user]

      value = user_params[:email]

      @auth_key = [:email, :name, :phone].find do |field|
        User.where(field => value).exists?
      end || :email

      if @auth_key != :email
        user_params.delete(:email)
        user_params[@auth_key] = value
      end
    end

    def set_devise_authentication_keys
      Devise.authentication_keys = [@auth_key]
    end
end
