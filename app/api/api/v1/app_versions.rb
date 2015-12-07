require 'markdown_render'

module Api::V1
  class AppVersions < Grape::API
    resource :app_versions do
      desc 'Get newest app version'
      get :newest do
        app_version = AppVersion.newest.first
        respond_error!('没有最新版本') unless app_version
        respond_ok(version: app_version.version)
      end

      desc 'Get url with the specified version'
      params do
        requires :version, type: String, desc: 'app version'
      end
      get 'url' do
        app_version = AppVersion.by_version(params[:version]).first
        respond_error!('没有这个版本的App') unless app_version
        full_url = "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{app_version.app.url}"
        respond_ok(url: full_url)
      end

      desc 'Get changelog with the specified version'
      params do
        requires :version, type: String, desc: 'app version'
      end
      get 'changelog' do
        app_version = AppVersion.by_version(params[:version]).first
        respond_error!('没有这个版本的App') unless app_version
        ActiveSupport::JSON::Encoding.escape_html_entities_in_json = false
        respond_ok(changelog: MarkdownRender.markdown(app_version.changelog))
      end

    end
  end
end
