module Api::V1
  class Friends < Grape::API
    resource :friends do
      before do
        doorkeeper_authorize!
      end

      desc 'get friends list'
      get do
        friends = paginate(current_user.friends.name_ordered)

        present friends, with: Api::Entities::Friend
        present paginate_record_for(friends), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'get pending friends list'
      get :pending do
        friends = paginate(current_user.pending_friends.name_ordered)

        present friends, with: Api::Entities::PendingFriend
        present paginate_record_for(friends), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'add friend request'
      params do
        requires :friend_id, type: String
      end
      post do
        friend = User.find(params[:friend_id])
        current_user.be_friends_with(friend)
        respond_ok  
      end

      desc 'accept add friend request'
      params do
        requires :friend_id, type: String
      end
      post :accept do
        friend = User.find(params[:friend_id])
        current_user.be_friends_with(friend)
        respond_ok  
      end

      desc 'deny add friend request'
      params do
        requires :friend_id, type: String
      end
      delete :deny do
        friend = User.find(params[:friend_id])
        current_user.delete_friend(friend)
        respond_ok  
      end

      desc 'delete a friend'
      delete ':friend_id' do
        friend = User.find(params[:friend_id])
        current_user.delete_friend(friend)
        respond_ok
      end
    end
  end
end
