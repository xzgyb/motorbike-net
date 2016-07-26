class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url
  end

  protected

  def configure_permitted_parameters
    extra_user_fields = [:email, :phone, :name, bikes_attributes: [:module_id, :name, :_destroy, :id, :iccid]]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_user_fields)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_user_fields)
  end
end
