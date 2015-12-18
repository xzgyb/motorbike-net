class BikesController < ApplicationController
  load_and_authorize_resource :user
  decorates_assigned :users, :bike, :bikes, :user

  def all
    @users = User.order_by(['name']).page(params[:page])
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
      gon.travelTrackHistories = @bike.locations
      gon.userName = @user.name
      gon.bikeName = @bike.name
    end
  end
end
