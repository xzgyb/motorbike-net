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
            images_attributes: [:id, :file, :_destroy])
        end
      end
      
      desc 'get activities list'
      params do
        optional :longitude, type: Float
        optional :latitude,  type: Float
        optional :page,      type: Integer
        optional :per_page,  type: Integer
        optional :max_distance, type: Integer
      end
      get do
        longitude = params[:longitude] || 0
        latitude  = params[:latitude] || 0

        if params[:max_distance].present?
          page     = params[:page] || 1
          per_page = params[:per_page] || 25

          activities = Action.nearby_actions(current_user, 
                                          'activity',
                                          [longitude, latitude],
                                          max_distance: params[:max_distance],
                                          page: page,
                                          per_page: per_page)
        else
          activities = Action.circle_actions_for(current_user).activity.latest
          activities = paginate(activities)
        end

        present activities, with: Api::Entities::Activity
        present paginate_record_for(activities), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'create a activity'
      post do
        activity = current_user.actions.activities.new(activity_params)
        activity.save!

        ActionPushJob.perform_later(current_user, 
                                    activity, 
                                    ActionPushJob::ACTION_ADD)

        respond_ok
      end

      desc 'get a activity'
      get ':id' do
        activity = Action.find(params[:id])

        present activity, with: Api::Entities::Activity, export_content: true
        respond_ok
      end

      desc 'delete a activity'
      delete ':id' do
        activity = current_user.actions.activities.find(params[:id])
        activity.destroy!

        ActionPushJob.perform_later(current_user, 
                                    activity, 
                                    ActionPushJob::ACTION_DELETE)

        respond_ok
      end

      desc 'update a activity'
      put ':id' do
        activity = current_user.actions.activities.find(params[:id])
        activity.update!(activity_params)

        ActionPushJob.perform_later(current_user, 
                                    activity, 
                                    ActionPushJob::ACTION_UPDATE)

        respond_ok
      end
    end
  end
end
