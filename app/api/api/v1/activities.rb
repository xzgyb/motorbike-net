module Api::V1
  class Activities < Grape::API
    resource :activities do
      before do
        doorkeeper_authorize!
      end

      helpers do
        def activity_params
          ActionController::Parameters.new(params).permit(
            :title, :price, :place, :content, :start_at, 
            :end_at, :longitude, :latitude,
            images_attributes: [:id, :file, :_destroy],
            participations_attributes: [:id, :user_id, :_destroy])
        end
      end
      
      desc 'get activities list'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
        optional :page,      type: Integer
        optional :per_page,  type: Integer
        optional :max_distance, type: Integer
      end
      get do
        activities = Activity.select_all_with_distance(params[:longitude],
                                                       params[:latitude])
                             .circle_for(current_user)

        if params[:max_distance].present?
          activities = activities.near(params[:longitude],
                                       params[:latitude],
                                       params[:max_distance])
        end

        activities = paginate(activities.latest)

        present activities, with: Api::Entities::Activity
        present paginate_record_for(activities), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc "get the specified user's activities list"
      get '/of_user/:user_id' do
        activities = Activity.select_all_with_distance(nil, nil)
                             .where(user_id: params[:user_id])
        activities = paginate(activities.latest)

        present activities, with: Api::Entities::Activity
        present paginate_record_for(activities), with: Api::Entities::Paginate
       
        respond_ok
      end
      

      desc 'create a activity'
      params do
        requires :title, type: String
        requires :place, type: String
        requires :price, type: String
        requires :longitude, type: Float, values: -180.0..+180.0
        requires :latitude,  type: Float, values: -90.0..+90.0
        requires :start_at, type: String
        requires :end_at, type: String
        optional :images_attributes, type: Array
        optional :participations_attributes, type: Array
      end
      post do
        normalize_uploaded_file_attributes(params[:images_attributes])

        activity = current_user.activities.new(activity_params)
        activity.save!
        respond_ok
      end

      desc 'get a activity'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
      end
      get ':id' do
        activity = Activity.select_all_with_distance(params[:longitude],
                                                   params[:latitude])
                           .find(params[:id])

        present activity, with: Api::Entities::Activity, export_detail: true
        respond_ok
      end

      desc 'delete a activity'
      delete ':id' do
        activity = current_user.activities.find(params[:id])
        activity.destroy!
        respond_ok
      end

      desc 'update a activity'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
        optional :images_attributes, type: Array
        optional :participations_attributes, type: Array
      end
      put ':id' do
        activity = current_user.activities.find(params[:id])
        normalize_uploaded_file_attributes(params[:images_attributes])

        activity.update!(activity_params)
        respond_ok
      end

      desc 'participate a activity'
      put ':id/participate' do
        activity = Activity.find(params[:id])
        activity.update!(participations_attributes: [{user_id: current_user.id}])

        respond_ok
      end
    end
  end
end
