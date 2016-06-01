require 'test_helper'

class MediasApiTest < ActiveSupport::TestCase
  def setup
    @current_user = create(:user)
    login_user(@current_user)
  end

  test "POST /api/v1/medias should creat a media for current user" do
    file = Rack::Test::UploadedFile.new(Rails.root.join("test/files/sample.jpg"),
                                        "image/jpg")
    post "/api/v1/medias",
      type: 1,
      media: file,
      access_token: token

    assert last_response.created?
  end

  test "GET /api/v1/medias should get a medias list of current user" do
    create_list(:media, 5, user: @current_user) 
    get "/api/v1/medias", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "medias"

    %w[id type url].each do |field|
      assert_includes result["medias"][0], field
    end
  end

  test "GET /api/v1/medias?:type should get the specified type medias list of current user" do
    create_list(:media, 2, type: 1, user: @current_user)
    create_list(:media, 2, type: 2, user: @current_user)

    get "/api/v1/medias?type=2", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)
    assert_includes result, "medias"

    0.upto(result["medias"].count - 1) do |index|
      assert_equal 2, result["medias"][index]["type"]
    end
  end

  test "DELETE /api/v1/medias/:id should work" do
    create_list(:media, 5, user: @current_user)

    assert_difference 'Media.count', -1 do
      delete "/api/v1/medias/#{@current_user.medias.first.id}",
        access_token: token
      assert last_response.ok?
    end
  end

  test "DELETE /api/v1/medias should clear all medias of current user" do
    create_list(:media, 5, user: @current_user)
    delete "/api/v1/medias", access_token: token
    assert last_response.ok?
    assert_equal 0, @current_user.medias.count
  end

  test "DELETE /api/v1/medias?type should clear the specified type medias of current user" do
    create_list(:media, 2, type: 1, user: @current_user)
    create_list(:media, 2, type: 2, user: @current_user)

    delete "/api/v1/medias?type=1", access_token: token
    assert last_response.ok?
    assert_equal 2, @current_user.medias.count

  end
end
