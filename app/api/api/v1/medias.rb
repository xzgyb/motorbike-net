module Api::V1
  class Medias < Grape::API

    resource :medias do
      before { doorkeeper_authorize! }
      
      desc 'Upload media files'
      params do
        requires :media, type: Rack::Multipart::UploadedFile
        requires :type, type: Integer, values: [1, 2, 3]
      end
      put :upload do
        media = Media.new

        media.media = params[:media]
        media.type  = params[:type]
        media.user  = current_user

        media.save!
        respond_ok
      end
    end
  end
end
