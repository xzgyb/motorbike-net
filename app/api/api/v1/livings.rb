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
            videos_attributes: [:id, :file, :_destroy])
        end
      end
      
      desc 'get livings list'
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

        livings = Action.near([longitude, latitude], 
                              page: page, 
                              per_page: per_page,
                              match: { '_enumtype': 'living' })

        present livings, with: Api::Entities::Living
        present paginate_record_for(livings), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'create a living'
      post do
        Action.living.create!(living_params)

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
        living = Action.find(params[:id])
        living.destroy!
        respond_ok
      end

      desc 'update a living'
      put ':id' do
        living = Action.find(params[:id])
        living.update!(living_params)

        respond_ok
      end



    end
  end
end
