module Api::V1
  class Medias < Grape::API

    resource :medias do
      before { doorkeeper_authorize! }
      
      desc 'Upload media file'
      params do
        requires :media, type: Rack::Multipart::UploadedFile
        requires :type, type: Integer, values: [1, 2, 3]
      end
      post do
        media = Media.new

        media.media = params[:media]
        media.type  = params[:type]
        media.user  = current_user

        media.save!
        respond_ok
      end

      desc "get current user's media files list"
      params do
        optional :type, type: Integer, values: [1, 2, 3]
      end
      get do
        if params[:type].present?
          medias = current_user.medias.of_type(params[:type])
        else
          medias = current_user.medias
        end

        present medias, with: Api::Entities::Media
        respond_ok
      end

      desc 'destroy a media file for current user'
      delete ':id' do
        media = current_user.medias.find(params[:id])

        media.destroy!
        respond_ok
      end

      desc "clear current user's media files" 
      params do
        optional :type, type: Integer, values: [1, 2, 3]
      end
      delete do
        if params[:type].present?
          medias = current_user.medias.of_type(params[:type])
        else
          medias = current_user.medias
        end

        medias.delete_all

        respond_ok
      end

    end
  end
end
