module Api::V1
  class Actions < Grape::API
    resource :actions do
      before do
        doorkeeper_authorize!
      end

      desc 'get actions list'
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

        actions = Action.near([longitude, latitude], 
                              page: page, 
                              per_page: per_page)

        present actions, with: Api::Entities::Action
        present paginate_record_for(actions), with: Api::Entities::Paginate
       
        respond_ok
      end
    end
  end
end
