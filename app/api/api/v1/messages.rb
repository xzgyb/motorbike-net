module Api::V1
  class Messages < Grape::API
    resource :messages do
      before do
        doorkeeper_authorize!
      end

      desc 'get messages list'
      params do
        optional :page,      type: Integer
        optional :per_page,  type: Integer
      end
      get do
        messages = paginate(current_user.messages.latest)

        present messages, with: Api::Entities::Message
        present paginate_record_for(messages), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'mark messages as read'
      put 'mark_as_read' do
        Message.mark_all_read_for(current_user)
        respond_ok
      end

      desc 'get unread messages count'
      get 'unread_count' do
        unread_count = Message.unread_count_for(current_user)
        present(messages: { unread_count: unread_count })
        respond_ok 
      end

    end
  end
end

