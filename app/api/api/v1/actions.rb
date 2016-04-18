module Api::V1
  class Actions < Grape::API
    resource :actions do

      desc 'get actions list'
      get do
        actions = paginate(Action.latest)

        present actions, with: Api::Entities::Action
        present paginate_record_for(actions), with: Api::Entities::Paginate
       
        respond_ok
      end
    end
  end
end
