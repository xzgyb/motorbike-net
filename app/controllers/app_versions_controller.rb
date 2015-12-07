class AppVersionsController < ApplicationController
  load_and_authorize_resource
  decorates_assigned :app_versions, :app_version

  def index
    @app_versions = AppVersion.ordered.page(params[:page])
  end

  def create
    if @app_version.save
      redirect_to app_versions_url
    else
      render :new
    end
  end

  def destroy
    @app_version.destroy
    redirect_to app_versions_url
  end

  private
    def app_version_params
      params.require(:app_version).permit(:version, :changelog, :app)
    end
end
