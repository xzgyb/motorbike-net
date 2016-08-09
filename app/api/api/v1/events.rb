module Api::V1
  class Events < Grape::API
    resource :events do
      before do
        doorkeeper_authorize!
      end

      helpers do
        def event_params
          ActionController::Parameters.new(params).permit(
            :title, :place, :content, :start_at, 
            :end_at, :longitude, :latitude)
        end
      end

      desc 'get events list'
      params do
        optional :page,      type: Integer
        optional :per_page,  type: Integer
        optional :start_at,  type: DateTime
      end
      get do
        events = current_user.events

        if params[:start_at].present?
          events = events.where('start_at >= ?', [params[:start_at]])
        end

        events = paginate(events.latest)

        present events, with: Api::Entities::Event
        present paginate_record_for(events), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'create a event'
      params do
        optional :start_at, type: DateTime
      end
      post do
        event = current_user.events.new(event_params)
        event.event_type = :event 
        event.save!
        respond_ok
      end

      desc 'get a event'
      get ':id' do
        event = current_user.events.find(params[:id])
        present event, with: Api::Entities::Event
        respond_ok
      end

      desc 'delete a event'
      delete ':id' do
        event = current_user.events.find(params[:id])
        event.destroy!
        respond_ok
      end

      desc 'update a event'
      put ':id' do
        event = current_user.events.find(params[:id])
        event.update!(event_params)
        respond_ok
      end
    end
  end
end

