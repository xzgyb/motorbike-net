class BikesController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.order_by(['bike.name']).paginate(page: params[:page], per_page: 30)
  end
end
