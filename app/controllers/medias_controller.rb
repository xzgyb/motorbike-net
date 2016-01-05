class MediasController < ApplicationController
  def index
    @type = params[:type]
    if @type.present?
      @medias = Media.where(type: @type)
      render :gallery 
    else
      @images_count = Media.count_of(Media::IMAGE) 
      @videos_count = Media.count_of(Media::VIDEO) 
      @audios_count = Media.count_of(Media::AUDIO) 
    end
  end
end
