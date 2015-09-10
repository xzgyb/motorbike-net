class BikesController < ApplicationController
  load_and_authorize_resource
  decorates_assigned :users

  def index
    @users = User.order_by(['bike.name']).page(params[:page])
  end
end
