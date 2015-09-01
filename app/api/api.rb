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
            :name, :longitude, :latitude, :battery, :travel_mileage)
        end
      end 

      params do
        requires :bike, type: Hash do
          requires :name, type: String
          requires :longitude, type: Float
          requires :latitude, type: Float
          requires :battery, type: Float
          requires :travel_mileage, type: Float
        end
      end

      put ':module_id' do
        user = User.find_by(module_id: params[:module_id])       
        user.bike.update!(bike_params)
        {status: "success"}
      end
    end

    route :any, '*path' do
      error! 'Not found', 404
    end
  end
end
