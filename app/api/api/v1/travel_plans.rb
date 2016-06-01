module Api::V1
  class TravelPlans < Grape::API
    resource :travel_plans do
      before { doorkeeper_authorize! }

      helpers do
        def travel_plan_params
          ActionController::Parameters.new(params).permit(
              :content, :start_off_time, :status, :dest_loc_longitude, :dest_loc_latitude, passing_locations_attributes: [:id, :longitude, :latitude, :_destroy])
        end
      end

      desc "get current user's travel plans list"
      get do
        travel_plans = current_user.travel_plans

        present travel_plans, with: Api::Entities::TravelPlan
        respond_ok
      end

      desc 'create a travel plan for current user'
      params do
        requires :content, type: String
        requires :start_off_time, type: Time
        requires :dest_loc_longitude, type: Float, values: -180.0..+180.0
        optional :dest_loc_latitude,  type: Float, values: -90.0..+90.0
        requires :status, type: Integer
        optional :passing_locations_attributes, type: Array
      end
      post do
        current_user.travel_plans.create!(travel_plan_params)
        respond_ok
      end

      desc 'update a travel plan for current user'
      params do
        optional :content, type: String
        optional :start_off_time, type: Time
        requires :dest_loc_longitude, type: Float, values: -180.0..+180.0
        optional :dest_loc_latitude,  type: Float, values: -90.0..+90.0
        optional :passing_locations_attributes, type: Array
        optional :status, type: Integer
      end
      put ':id' do
        travel_plan = current_user.travel_plans.find(params[:id])

        travel_plan.update!(travel_plan_params)
        respond_ok
      end

      desc 'destroy a travel plan for current user'
      delete ':id' do
        travel_plan = current_user.travel_plans.find(params[:id])

        travel_plan.destroy!
        respond_ok
      end

      desc 'get a travel plan for current user'
      get ':id' do
        travel_plan = current_user.travel_plans.find(params[:id])
        present travel_plan, with: Api::Entities::TravelPlan
        respond_ok
      end
    end
  end
end
