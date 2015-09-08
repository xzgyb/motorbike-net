class UsersController < ApplicationController
  load_and_authorize_resource
  
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
    def user_params
      params.require(:user).permit(:admin)
    end

end
