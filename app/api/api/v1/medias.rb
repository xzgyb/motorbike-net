module Api::V1
  class Medias < Grape::API

    resource :medias do
      before { doorkeeper_authorize! }

      put :upload do
        media = Media.new

        media.type  = params[:type]
        media.media = params[:media]
        media.user  = current_user

        media.save!
        respond_ok
      end
    end
  end
end
