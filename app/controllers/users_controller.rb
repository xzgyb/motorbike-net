class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, :check_admin, only: [:destroy, :update]
  
  def index
    @users = User.order_by(['email']).paginate(page: params[:page], per_page: 30)
  end

  def destroy
    @user.destroy
    redirect_to users_url  
  end

  def update
    @user.update(user_params)
    redirect_to users_url
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:admin)
  end

  def check_admin
    unless current_user.admin?
      redirect_to new_user_session_url
    end
  end
end
