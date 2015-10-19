module MotorbikeNet
  class API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api
    rescue_from :all

    resource :bikes do
     
      helpers do
        def bike_params
          
          ActionController::Parameters.new(params).require(:bike).permit(
            :name, :longitude, :latitude, :battery, :travel_mileage).tap do |whitelisted|
              if params[:bike][:diag_info]
                whitelisted[:diag_info] = params[:bike][:diag_info]
              end
            end
          
        end
      end 

      params do
        requires :bike, type: Hash do
          optional :name, type: String
          optional :longitude, type: Float
          optional :latitude, type: Float
          optional :battery, type: Float
          optional :travel_mileage, type: Float
          optional :diag_info, type: Hash
        end
      end

      put ':module_id' do
        user = User.find_by(module_id: params[:module_id])       
        bike = user.bike

        bike.assign_attributes(bike_params)

        bike_data = params[:bike]

        if bike_data.has_key?(:longitude) &&
           bike_data.has_key?(:latitude)
          
           bike.travel_track_histories.push([bike_data[:longitude],
                                             bike_data[:latitude]])
        end

        bike.save!

        {status: "success"}
      end
    end

    route :any, '*path' do
      error! 'Not found', 404
    end
  end
end
