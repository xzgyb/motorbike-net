class UsersController < ApplicationController
  load_and_authorize_resource
  decorates_assigned :users
  
  def index
    @users = User.order_by(['email']).page(params[:page])
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
    def user_params
      params.require(:user).permit(:admin)
    end

end
