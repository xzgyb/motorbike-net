class MediasController < ApplicationController
  authorize_resource
  
  def index
    @type = params[:type]
    if @type.present?
      @medias = current_user.medias.of_type(@type)
      render :gallery 
    else
      @images_count = current_user.medias.of_type(Media::IMAGE).count
      @videos_count = current_user.medias.of_type(Media::VIDEO).count
      @audios_count = current_user.medias.of_type(Media::AUDIO).count
    end
  end
end
