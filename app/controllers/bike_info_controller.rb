class BikeInfoController < ApplicationController
  decorates_assigned :bike

  def show
    authorize! :show, :bike
    user = User.find(params[:id])
    @bike = user.bike
    gon.longitude = @bike.longitude
    gon.latitude  = @bike.latitude 
    gon.travelTrackHistories = @bike.travel_track_histories
    gon.userName = user.name
  end
end
