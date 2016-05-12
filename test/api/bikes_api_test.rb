require 'test_helper'

class BikesApiTest < ActiveSupport::TestCase
  def setup
    @current_user = create(:user_with_bikes)
    @gyb = create(:user)
    create_friendship(@current_user, @gyb)
    @gyb.update_attribute(:online, true)
    login_user(@current_user)
  end
  
  test 'PUT /api/v1/bikes/upload/:module_id upload should work' do
    module_id = @current_user.bikes.first.module_id
    put "/api/v1/bikes/upload/#{module_id}", 
        longitude: 112.5,
        latitude: 88.2,
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
