module Api::V1
  class Bikes < Grape::API
    resource :bikes do
      before { doorkeeper_authorize! }

      helpers do
        def bike_params
          ActionController::Parameters.new(params).permit(
              :module_id, :name, :longitude, :latitude, :battery, :travel_mileage).tap do |whitelisted|
            if params[:diag_info]
              whitelisted[:diag_info] = params[:diag_info]
            end

            if params[:commands]
              whitelisted[:commands] = params[:commands]
            end
          end
        end
      end

      desc "get current user's bikes list"
      get do
        bikes = current_user.bikes

        present bikes, with: Api::Entities::Bike
        respond_ok
      end

      desc 'create a bike for current user'
      params do
        requires :module_id, type: String
        optional :name, type: String
      end
      post do
        current_user.bikes.create!(bike_params)
        respond_ok
      end

      desc 'update a bike for current user'
      put ':id' do
        bike = current_user.bikes.find(params[:id])

        bike.update!(bike_params)
        respond_ok
      end

      desc 'destroy a bike for current user'
      delete ':id' do
        bike = current_user.bikes.find(params[:id])

        bike.destroy!
        respond_ok
      end

      desc 'get a bike for current user by module id'
      get 'by_module_id/:module_id' do
        bike = current_user.bikes.find_by!(module_id: params[:module_id])
        present bike, with: Api::Entities::Bike
        respond_ok
      end

      desc 'get a bike for current user'
      get ':id' do
        bike = current_user.bikes.find(params[:id])
        present bike, with: Api::Entities::Bike
        respond_ok
      end

      desc 'Upload bike data with the module id'
      put 'upload/:module_id' do
        bike = current_user.bikes.find_by!(module_id: params[:module_id])
        
        # convert diag_info keys and values encoding, from gb2312 to utf-8
        if params[:diag_info]
          diag_info_pairs = params[:diag_info].map { |k, v|
            [k.to_s.encode('utf-8', 'gb2312'), v.to_s.encode('utf-8', 'gb2312')]
          } 

          params[:diag_info] = Hash[diag_info_pairs]
        end

        bike.update!(bike_params)

        if params.has_key?(:longitude) && params.has_key?(:latitude)
          current_user.update!(longitude: params[:longitude],
                               latitude: params[:latitude])

          bike.locations.create!(longitude: params[:longitude],
                                 latitude: params[:latitude])

          FriendLocationPushJob.perform_later(current_user, 
                                              params[:longitude],
                                              params[:latitude])
        end

        respond_ok
      end

      desc "Get locations data with the specified bike"
      get ':id/locations' do
        bike = current_user.bikes.find(params[:id])
        present bike.locations, with: Api::Entities::Location
        respond_ok
      end
    end

  end
end
