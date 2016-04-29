require 'test_helper'

class ActionsApiTest < ActiveSupport::TestCase

  test 'GET /api/v1/actions returns a actions list' do
    create(:activity_with_images, updated_at: Time.current)
    create(:living_with_videos, updated_at: 1.day.since)
    create(:take_along_something_with_images, updated_at: 2.days.since) 

    first_action = Action.first
    get '/api/v1/actions', longitude: first_action.longitude, latitude: first_action.latitude, access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal Action.count, result["actions"].count 
  end
end
