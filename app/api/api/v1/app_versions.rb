require 'markdown_render'

module Api::V1
  class AppVersions < Grape::API

    resource :app_versions do
      desc 'Get newest app version with the specified app name'
      params do
        requires :name, type: String, desc: 'app name'
      end
      get :newest do
        app_version = AppVersion.newest(params[:name]).first
        respond_error!('没有最新版本') unless app_version
        respond_ok(version: app_version.version)
      end

      desc 'Get url with the specified app name and version'
      params do
        requires :name, type: String, desc: 'app name'
        requires :version, type: String, desc: 'app version'
      end
      get 'url' do
        app_version = AppVersion.by_name_version(params[:name],
                                                 params[:version]).first

        respond_error!('没有这个版本的App') unless app_version
        respond_ok(url: app_version.app.url)
      end

      desc 'Get changelog with the specified app name and version'
      params do
        requires :name, type: String, desc: 'app name'
        requires :version, type: String, desc: 'app version'
      end
      get 'changelog' do
        app_version = AppVersion.by_name_version(params[:name],
                                                 params[:version]).first

        respond_error!('没有这个版本的App') unless app_version
        respond_ok(changelog: MarkdownRender.markdown(app_version.changelog))
      end

    end
  end
end
