class BikesController < ApplicationController
  MAX_POINTS = 300

  load_resource :user
  decorates_assigned :users, :bike, :bikes, :user

  def all
    @users = User.name_ordered.page(params[:page])
  end

  def index
    @bikes = @user.bikes
    @bike  = @bikes.first

    if @bike
      redirect_to user_bike_path(@user, @bike)
    else
      render 'no_bike'
    end
  end

  def show
    @bikes = @user.bikes
    @bike  = @user.bikes.find(params[:id])

    if @bike
      gon.longitude = @bike.longitude
      gon.latitude  = @bike.latitude

      count = @bike.locations.count
      offset = count > MAX_POINTS ? count - MAX_POINTS : 0

      locations = @bike.locations.offset(offset)

      gon.travelTrackHistories = locations.map do |location|
        {longitude: location.longitude,
         latitude: location.latitude}
      end

      gon.userName = @user.name
      gon.bikeName = @bike.name
    end
  end
end
