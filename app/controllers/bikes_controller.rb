class BikesController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.order_by(['bike.name']).paginate(page: params[:page], per_page: 30)
  end
end
