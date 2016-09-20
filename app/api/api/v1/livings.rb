module Api::V1
  class Livings < Grape::API
    resource :livings do
      before do
        doorkeeper_authorize!
      end

      helpers do
        def living_params
          ActionController::Parameters.new(params).permit(
            :title, :price, :place, :content, :longitude, :latitude,
            videos_attributes: [:id, :file, :_destroy],
            images_attributes: [:id, :file, :_destroy])
        end
      end
      
      desc 'get livings list'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
        optional :page,      type: Integer
        optional :per_page,  type: Integer
        optional :max_distance, type: Integer
        optional :circle,    type: Integer
      end
      get do
        livings = Living.select_all_with_distance(params[:longitude],
                                                  params[:latitude])

        if params[:circle].present? && params[:circle] == 1
          livings = livings.circle_for(current_user)
        end

        if params[:max_distance].present?
          livings = livings.near(params[:longitude],
                                 params[:latitude],
                                 params[:max_distance])
        end

        livings = paginate(livings.latest)

        present livings, with: Api::Entities::Living
        present paginate_record_for(livings), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc "get the specified user's livings list"
      get '/of_user/:user_id' do
        livings = Living.select_all_with_distance(nil, nil)
                        .where(user_id: params[:user_id])

        livings = paginate(livings.latest)

        present livings, with: Api::Entities::Living
        present paginate_record_for(livings), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'create a living'
      params do
        requires :title, type: String
        requires :place, type: String
        requires :price, type: String
        requires :longitude, type: Float, values: -180.0..+180.0
        requires :latitude,  type: Float, values: -90.0..+90.0
        optional :videos_attributes, type: Array
        optional :images_attributes, type: Array
      end
      post do
        normalize_uploaded_file_attributes(params[:videos_attributes])
        normalize_uploaded_file_attributes(params[:images_attributes])

        living = current_user.livings.new(living_params)
        living.save!
        respond_ok
      end

      desc 'get a living'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
      end
      get ':id' do
        living = Living.select_all_with_distance(params[:longitude],
                                                 params[:latitude])
                         .find(params[:id])

        present living, with: Api::Entities::Living, export_content: true
        respond_ok
      end

      desc 'reset livings'
      delete 'reset' do
        current_user.livings.destroy_all
        respond_ok
      end

      desc 'delete a living'
      delete ':id' do
        living = current_user.livings.find(params[:id])
        living.destroy!
        respond_ok
      end

      desc 'update a living'
      params do
        optional :longitude, type: Float, values: -180.0..+180.0
        optional :latitude,  type: Float, values: -90.0..+90.0
        optional :videos_attributes, type: Array
        optional :images_attributes, type: Array
      end
      put ':id' do
        living = current_user.livings.find(params[:id])
        
        normalize_uploaded_file_attributes(params[:videos_attributes])
        normalize_uploaded_file_attributes(params[:images_attributes])

        living.update!(living_params)
        respond_ok
      end

      desc 'create a like'
      post ':id/likes' do
        living = Living.find(params[:id])
        living.likes.find_or_create_by!(user: current_user)
        respond_ok
      end

      desc 'get likes'
      get ':id/likes' do
        living = current_user.livings.find(params[:id])

        likes = paginate(living.likes)

        present likes, with: Api::Entities::Like
        present paginate_record_for(likes), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'delete a like'
      delete 'likes/:id' do
        like = current_user.likes.find(params[:id])

        like.destroy!
        respond_ok
      end

      desc 'create a comment'
      params do
        requires :content, type: String
        optional :reply_to_user_id,  type: Integer
      end
      post ':id/comments' do
        living = Living.find(params[:id])

        attrs = { user: current_user,
                  content: params[:content] }

        if params[:reply_to_user_id].present?
          attrs[:reply_to_user_id] = params[:reply_to_user_id]
        end

        living.comments.create!(attrs)

        respond_ok
      end

      desc 'get comments'
      get ':id/comments' do
        living = current_user.livings.find(params[:id])

        comments = paginate(living.comments)

        present comments, with: Api::Entities::Comment
        present paginate_record_for(comments), with: Api::Entities::Paginate
       
        respond_ok
      end

      desc 'delete a comment'
      delete 'comments/:id' do
        comment = current_user.comments.find(params[:id])

        comment.destroy!
        respond_ok
        
      end
    end
  end
end
