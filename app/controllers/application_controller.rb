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
    extra_user_fields = [:name, :module_id]
    devise_parameter_sanitizer.for(:sign_up).concat extra_user_fields 
    devise_parameter_sanitizer.for(:account_update).concat extra_user_fields
  end
end
