module Api::V1
  class Livings < Grape::API
    resource :livings do
      helpers do
        def living_params
          ActionController::Parameters.new(params).permit(
            :title, :price, :place, :content, :longitude, :latitude,
            videos_attributes: [:id, :file, :_destroy])
        end
      end
      
      desc 'get livings list'
      get do
        livings = paginate(Action.living.latest)

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
