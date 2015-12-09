module Api::V1
  class TravelPlans < Grape::API
    resource :travel_plans do
      before { doorkeeper_authorize! }

      helpers do
        def travel_plan_params
          ActionController::Parameters.new(params).permit(
              :content, :start_off_time, :status, passing_locations: [], destination_location: [])
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
        requires :destination_location, type: Array
        requires :status, type: Integer
        optional :passing_locations, type: Array
      end
      post do
        current_user.travel_plans.create!(travel_plan_params)
        respond_ok
      end

      desc 'update a travel plan for current user'
      params do
        optional :start_off_time, type: Time
        optional :destination_location, type: Array
        optional :passing_locations, type: Array
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
