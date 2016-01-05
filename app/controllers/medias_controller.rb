class MediasController < ApplicationController
  before_action :doorkeeper_authorize!, only: :upload

#  include Api::Helpers

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

  def upload
    media = Media.new(media_params)
    media.user = current_resource_owner

    if media.save
      render json: {result: 1}
    else
      render json: {result: 0, error: media.errors.full_messages}
    end
  end

  private
    def media_params
      params.permit(:media, :type)
    end

    def current_resource_owner
      @current_resource_owner ||= 
        User.where(id: doorkeeper_token.resource_owner_id).first if doorkeeper_token
    end

end
