module Api::V1
  class TakeAlongSomethings < Grape::API
    resource :take_along_somethings do
      helpers do
        def take_along_something_params
          ActionController::Parameters.new(params).permit(
            :title, :price, :place, :content, :start_at, :end_at, coordinates: [],
            images_attributes: [:id, :file, :_destroy])
        end
      end
      
      desc 'get take_along_somethings list'
      get do
        take_along_somethings = paginate(Action.take_along_something.latest)

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
