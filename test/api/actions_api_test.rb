require 'test_helper'

class ActionsApiTest < ActiveSupport::TestCase

  test 'GET /api/v1/actions returns a actions list' do
    create(:activity_with_images, updated_at: Time.current)
    create(:living_with_videos, updated_at: 1.day.since)
    create(:take_along_something_with_images, updated_at: 2.days.since) 

    get '/api/v1/actions', access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal Action.count, result["actions"].count 

    assert_equal "take_along_something", result["actions"][0]["type"]
    assert_equal "living", result["actions"][1]["type"]
    assert_equal "activity", result["actions"][2]["type"]

    assert_includes result["actions"][1], "videos"
    assert_not_includes result["actions"][1], "start_at"
    assert_not_includes result["actions"][1], "end_at"

    assert_includes result["actions"][0], "images"
    assert_includes result["actions"][2], "images"

    assert_includes result["actions"][0], "start_at"
    assert_includes result["actions"][0], "end_at"

    assert_includes result["actions"][2], "start_at"
    assert_includes result["actions"][2], "end_at"
  end
end
