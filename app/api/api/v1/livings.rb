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
        livings = Action.select_all_with_distance(params[:longitude],
                                                  params[:latitude])
                        .circle_for(current_user)
                        .living

        if params[:max_distance].present?
          livings = livings.near(params[:longitude],
                                 params[:latitude],
                                 params[:max_distance])
        end

        livings = paginate(livings.latest)

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

        living = current_user.livings.new(living_params)
        living.save!

        ActionPushJob.perform_later(current_user, 
                                    living, 
                                    ActionPushJob::ACTION_ADD)
        respond_ok
      end

      desc 'get a living'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
      end
      get ':id' do
        living = Action.select_all_with_distance(params[:longitude],
                                                 params[:latitude])
                         .find(params[:id])

        present living, with: Api::Entities::Living, export_content: true
        respond_ok
      end

      desc 'delete a living'
      delete ':id' do
        living = current_user.livings.find(params[:id])
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
        living = current_user.livings.find(params[:id])
        
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
