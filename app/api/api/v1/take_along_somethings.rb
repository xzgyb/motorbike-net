module Api::V1
  class TakeAlongSomethings < Grape::API
    resource :take_along_somethings do
      before do
        doorkeeper_authorize!
      end

      helpers do
        def take_along_something_params
          ActionController::Parameters.new(params).permit(
            :title, :price, :place, :content, :start_at, :end_at, :longitude, :latitude,
            images_attributes: [:id, :file, :_destroy])
        end
      end
      
      desc 'get take_along_somethings list'
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

        take_along_somethings = Action.near([longitude, latitude], 
                                            page: page, 
                                            per_page: per_page,
                                            match: { '_enumtype': 'take_along_something' })

        present take_along_somethings, with: Api::Entities::TakeAlongSomething
        present paginate_record_for(take_along_somethings), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'create a take_along_something'
      post do
        Action.take_along_something.create!(take_along_something_params)

        respond_ok
      end

      desc 'get a take_along_something'
      get ':id' do
        take_along_something = Action.find(params[:id])

        present take_along_something, with: Api::Entities::TakeAlongSomething, export_content: true
        respond_ok
      end

      desc 'delete a take_along_something'
      delete ':id' do
        take_along_something = Action.find(params[:id])
        take_along_something.destroy!
        respond_ok
      end

      desc 'update a take_along_something'
      put ':id' do
        take_along_something = Action.find(params[:id])
        take_along_something.update!(take_along_something_params)

        respond_ok
      end
    end
  end
end
