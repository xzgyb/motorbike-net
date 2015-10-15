class BikeInfoController < ApplicationController
  decorates_assigned :bike

  def show
    authorize! :show, :bike
    user = User.find(params[:id])
    @bike = user.bike
  end
end
