require 'test_helper'

class AppVersionsApiTest < ActiveSupport::TestCase
  def setup
    @app_version = create(:app_version)
  end

  test "GET /api/v1/app_versions/newest should the newest version" do
    get '/api/v1/app_versions/newest', name: @app_version.name
    assert last_response.ok?

    result = JSON.parse(last_response.body)
    assert_includes result, "version"
  end

  test "GET /api/v1/app_versions/url should work" do

    get '/api/v1/app_versions/url', name: @app_version.name,
                                    version: @app_version.version

    assert last_response.ok?
    result = JSON.parse(last_response.body)
    assert_includes result, "url"
  end

  test "GET /api/v1/app_versions/changelog should work" do
    get '/api/v1/app_versions/changelog', name: @app_version.name,
                                          version: @app_version.version

     
    assert last_response.ok?
    result = JSON.parse(last_response.body)
    assert_includes result, "changelog" 
  end

end
