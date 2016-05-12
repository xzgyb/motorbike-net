require 'test_helper'

class ActionsApiTest < ActiveSupport::TestCase
  def setup
    @current_user = create(:user)
    @gyb = create(:user, name: 'gyb')
    @ww  = create(:user, name: 'ww')

    create_friendship(@current_user, @gyb)
    create_friendship(@current_user, @ww)

    login_user(@current_user)
  end

  test 'GET /api/v1/actions returns a actions list' do
    create(:activity_with_images, updated_at: Time.current, user: @current_user)
    create(:living_with_videos, updated_at: 1.day.since, user: @gyb)
    create(:take_along_something_with_images, updated_at: 2.days.since, user: @ww) 
    create(:take_along_something_with_images, updated_at: 2.days.since, user: create(:user)) 

    first_action = @current_user.actions.first
    get '/api/v1/actions', longitude: first_action.longitude, latitude: first_action.latitude, access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal 3, result["actions"].count 
  end

  test 'GET /api/v1/actions with max_distance returns a nearby actions list' do
    create_list(:activity_with_images, 10, coordinates:[33.5, 55.8], user: @current_user) 
    get '/api/v1/actions', longitude: 33.5, latitude: 55.8, max_distance: 5,
        access_token: token

    assert last_response.ok?
  end
end
