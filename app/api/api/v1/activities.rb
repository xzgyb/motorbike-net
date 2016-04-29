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
      end
      get do
        longitude = params[:longitude] || 0
        latitude  = params[:latitude] || 0
        page      = params[:page] || 1
        per_page  = params[:per_page] || 25

        
        activities = Action.near([longitude, latitude], 
                                 page: page, 
                                 per_page: per_page,
                                 match: { '_enumtype': 'activity' })

        present activities, with: Api::Entities::Activity
        present paginate_record_for(activities), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'create a activity'
      post do
        Action.activity.create!(activity_params)

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
        activity = Action.find(params[:id])
        activity.destroy!
        respond_ok
      end

      desc 'update a activity'
      put ':id' do
        activity = Action.find(params[:id])
        activity.update!(activity_params)

        respond_ok
      end



    end
  end
end
