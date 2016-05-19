module Api::V1
  class Livings < Grape::API
    resource :livings do
      before do
        doorkeeper_authorize!
      end

      helpers do
        def living_params
          ActionController::Parameters.new(params).permit(
            :title, :price, :place, :content, :longitude, :latitude,
            videos_attributes: [:id, :file, :_destroy],
            images_attributes: [:id, :file, :_destroy])
        end
      end
      
      desc 'get livings list'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
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

          livings = Action.nearby_actions(current_user, 
                                          'living',
                                          [longitude, latitude],
                                          max_distance: params[:max_distance],
                                          page: page,
                                          per_page: per_page)
        else
          livings = Action.circle_actions_for(current_user).living.latest
          livings = paginate(livings)
        end

        present livings, with: Api::Entities::Living
        present paginate_record_for(livings), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'create a living'
      params do
        requires :title, type: String
        requires :place, type: String
        requires :price, type: String
        requires :longitude, type: Float, values: -180.0..+180.0
        requires :latitude,  type: Float, values: -90.0..+90.0
        optional :videos_attributes, type: Array
        optional :images_attributes, type: Array
      end
      post do
        normalize_uploaded_file_attributes(params[:videos_attributes])
        normalize_uploaded_file_attributes(params[:images_attributes])

        living = current_user.actions.livings.new(living_params)
        living.save!

        ActionPushJob.perform_later(current_user, 
                                    living, 
                                    ActionPushJob::ACTION_ADD)
        respond_ok
      end

      desc 'get a living'
      get ':id' do
        living = Action.find(params[:id])

        present living, with: Api::Entities::Living, export_content: true
        respond_ok
      end

      desc 'delete a living'
      delete ':id' do
        living = current_user.actions.livings.find(params[:id])
        living.destroy!

        ActionPushJob.perform_later(current_user, 
                                    living, 
                                    ActionPushJob::ACTION_DELETE)
        respond_ok
      end

      desc 'update a living'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
        optional :videos_attributes, type: Array
        optional :images_attributes, type: Array
      end
      put ':id' do
        living = current_user.actions.livings.find(params[:id])
        
        normalize_uploaded_file_attributes(params[:videos_attributes])
        normalize_uploaded_file_attributes(params[:images_attributes])

        living.update!(living_params)

        ActionPushJob.perform_later(current_user, 
                                    living, 
                                    ActionPushJob::ACTION_UPDATE)
        respond_ok
      end
    end
  end
end
