require 'test_helper'

class TravelPlansApiTest < ActiveSupport::TestCase

  def setup
    @current_user = create(:user)
    login_user(@current_user)
  end

  test "GET /api/v1/travel_plans should get current user's travel plans" do
    create_list(:travel_plan_with_passing_locations, 5, user: @current_user)
    get '/api/v1/travel_plans', access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)
    assert_includes result, 'travel_plans'

    assert_equal 5, result["travel_plans"].count
    %w[id content dest_loc_longitude dest_loc_latitude status passing_locations].each do |field|
      assert_includes result["travel_plans"][0], field
    end

    %w[longitude latitude].each do |field|
      assert_includes result["travel_plans"][0]["passing_locations"][0], field
    end
  end

  test "POST /api/v1/travel_plans should create a travel plan for current user" do
    post '/api/v1/travel_plans',
      content: 'hello travel',
      start_off_time: '2016-06-01 08:00:00',
      dest_loc_longitude: 33.8,
      dest_loc_latitude: 44.5,
      status: 1,
      passing_locations_attributes: [
        {longitude: 22.3, latitude: 33.5},
        {longitude: 22.8, latitude: 34.4}
      ],
      access_token: token

    assert last_response.created?
  end

  test "PUT /api/v1/travel_plans/:id should update a travel plan for current user" do
    create(:travel_plan_with_passing_locations, user: @current_user)
    travel_plan = @current_user.travel_plans.first

    put "/api/v1/travel_plans/#{travel_plan.id}",
      content: 'hello travel',
      start_off_time: '2016-06-01 08:00:00',
      dest_loc_longitude: 33.8,
      dest_loc_latitude: 44.5,
      status: 1,
      passing_locations_attributes: [
        {longitude: 22.3, latitude: 33.5},
        {longitude: 22.8, latitude: 34.4}
      ],
      access_token: token

    assert last_response.ok?
  end

  test "DELETE /api/v1/travel_plans/:id should delete a travel plan for current user" do
    create(:travel_plan_with_passing_locations, user: @current_user)
    travel_plan = @current_user.travel_plans.first

    assert_difference 'TravelPlan.count', -1 do
      delete "/api/v1/travel_plans/#{travel_plan.id}",
        access_token: token
      assert last_response.ok?
    end
  end

  test "GET /api/v1/travel_plans/:id should get a travel plan for current user" do
    create(:travel_plan_with_passing_locations, user: @current_user)
    travel_plan = @current_user.travel_plans.first

    get "/api/v1/travel_plans/#{travel_plan.id}",
        access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)
    assert_includes result, 'travel_plan'

    %w[id content dest_loc_longitude dest_loc_latitude status passing_locations].each do |field|
      assert_includes result['travel_plan'], field
    end

    %w[longitude latitude].each do |field|
      assert_includes result['travel_plan']['passing_locations'][0], field
    end
  end
end
