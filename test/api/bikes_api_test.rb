require 'test_helper'

class BikesApiTest < ActiveSupport::TestCase
  def setup
    @current_user = create(:user_with_bikes)
    @gyb = create(:user)
    create_friendship(@current_user, @gyb)
    @gyb.update_attribute(:online, true)
    login_user(@current_user)
  end

  test "GET /api/v1/bikes should a current user's bikes list" do
    get '/api/v1/bikes', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)
    assert_includes result, "bikes"
  end

  test "POST /api/v1/bikes should create a bike" do
    old_bikes_count = @current_user.bikes.count

    post '/api/v1/bikes', module_id: "123safasdf",
                          name: "ggg", 
                          access_token: token

    assert last_response.created?
    assert_equal old_bikes_count + 1, @current_user.bikes.count
  end

  test "PUT /api/v1/bikes/:id should update the specified id bike info of  current user" do
    bike = @current_user.bikes.first
    put "/api/v1/bikes/#{bike.id}", name: "123g", 
                                    diag_info: {"hello":"gg", "dsf":"333"},
                                    access_token: token
    assert last_response.ok?
  end

  test "DELETE /api/v1/bikes/:id should delete the specified id bike of current user" do
    bike = @current_user.bikes.first
    old_bikes_count = @current_user.bikes.count

    delete "/api/v1/bikes/#{bike.id}", access_token: token
    assert last_response.ok?
    assert_equal old_bikes_count - 1, @current_user.bikes.count
  end

  test 'GET /api/v1/bikes/:id should workd' do
    bike = @current_user.bikes.first

    get "/api/v1/bikes/#{bike.id}", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, 'bike'
  end

  test 'PUT /api/v1/bikes/upload/:module_id upload should work' do
    module_id = @current_user.bikes.first.module_id
    put "/api/v1/bikes/upload/#{module_id}", 
        longitude: 112.5,
        latitude: 88.2,
        diag_info: { "hello": "ok" },
        access_token: token

    assert last_response.ok?
  end

  test 'GET /api/v1/bikes/:id/locations returns a locations list' do
    bike = @current_user.bikes.first
    get "/api/v1/bikes/#{bike.id}/locations", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "locations"

    assert_equal bike.locations.count, result["locations"].count
  end
end
