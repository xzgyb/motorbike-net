module Api::V1
  class Actions < Grape::API
    resource :actions do
      before do
        doorkeeper_authorize!
      end

      desc 'get actions list'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
        optional :page,      type: Integer
        optional :per_page,  type: Integer
        optional :max_distance, type: Integer
      end
      get do
        actions = Action.select_all_with_distance(params[:longitude],
                                                  params[:latitude])
                        .circle_for(current_user)
                        .sponsor

        if params[:max_distance].present?
          actions = actions.near(params[:longitude],
                                 params[:latitude],
                                 params[:max_distance])
        end

        actions = paginate(actions.latest)

        present actions, with: Api::Entities::Action
        present paginate_record_for(actions), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc "get the specified user's actions list"
      params do
        optional :action_type, type: String
      end
      get '/of_user/:user_id' do
        actions = Action.select_all_with_distance(nil, nil)
                        .where(user_id: params[:user_id])

        if params[:action_type].present?
          if params[:action_type] == "sponsor"
            actions = actions.sponsor
          elsif params[:action_type] == "participant"
            actions = actions.participant
          end
        end

        actions = paginate(actions.latest)

        present actions, with: Api::Entities::Action
        present paginate_record_for(actions), with: Api::Entities::Paginate
       
        respond_ok
      end
    end
  end
end
