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
            images_attributes: [:id, :file, :_destroy],
            sender_attributes: [:id, :name, :phone, :address, :_destroy],
            receiver_attributes: [:id, :name, :phone, :address, :_destroy])
        end
      end
      
      desc 'get take_along_somethings list'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
        optional :page,      type: Integer
        optional :per_page,  type: Integer
        optional :max_distance, type: Integer
      end
      get do
        take_along_somethings = Action.select_all_with_distance(params[:longitude],
                                                               params[:latitude])
                                      .circle_for(current_user)
                                      .take_along_something

        if params[:max_distance].present?
          take_along_somethings = take_along_somethings.near(params[:longitude],
                                                             params[:latitude],
                                                             params[:max_distance])
        end

        take_along_somethings = paginate(take_along_somethings.latest)

        present take_along_somethings, with: Api::Entities::TakeAlongSomething
        present paginate_record_for(take_along_somethings), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc "get the specified user's take along somethings list"
      get '/of_user/:user_id' do
        take_along_somethings = Action.select_all_with_distance(nil, nil)
                                      .where(user_id: params[:user_id])
                                      .take_along_something
        take_along_somethings = paginate(take_along_somethings.latest)

        present take_along_somethings, with: Api::Entities::TakeAlongSomething
        present paginate_record_for(take_along_somethings), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'create a take_along_something'
      params do
        requires :title, type: String
        requires :place, type: String
        requires :price, type: String
        requires :longitude, type: Float, values: -180.0..+180.0
        requires :latitude,  type: Float, values: -90.0..+90.0
        requires :start_at, type: String
        requires :end_at, type: String
        optional :images_attributes, type: Array
        optional :sender_attributes, type: Hash
        optional :receiver_attributes, type: Hash
      end
      post do
        normalize_uploaded_file_attributes(params[:images_attributes])

        take_along_something = current_user.take_along_somethings.new(
          take_along_something_params)

        take_along_something.save!

        ActionPushJob.perform_later(current_user, 
                                    take_along_something, 
                                    ActionPushJob::ACTION_ADD)
        respond_ok
      end

      desc 'get a take_along_something'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
      end
      get ':id' do
        take_along_something = Action.select_all_with_distance(params[:longitude],
                                                               params[:latitude])
                                     .find(params[:id])

        present take_along_something, with: Api::Entities::TakeAlongSomething, export_content: true
        respond_ok
      end

      desc 'delete a take_along_something'
      delete ':id' do
        take_along_something = current_user.take_along_somethings.find(params[:id])
        take_along_something.destroy!

        ActionPushJob.perform_later(current_user, 
                                    take_along_something, 
                                    ActionPushJob::ACTION_DELETE)
        respond_ok
      end

      desc 'update a take_along_something'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
        optional :images_attributes, type: Array
        optional :sender_attributes, type: Hash
        optional :receiver_attributes, type: Hash
      end
      put ':id' do
        take_along_something = current_user.take_along_somethings.find(params[:id])
        normalize_uploaded_file_attributes(params[:images_attributes])

        take_along_something.update!(take_along_something_params)

        ActionPushJob.perform_later(current_user, 
                                    take_along_something, 
                                    ActionPushJob::ACTION_UPDATE)

        respond_ok
      end
    end
  end
end
