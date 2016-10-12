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
    create_activity(@current_user)
    create_living(@gyb)
    create_take_along_something(@ww)
    create_take_along_something(create(:user))

    first_action = @current_user.actions.first
    get '/api/v1/actions', longitude: first_action.longitude, latitude: first_action.latitude, access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal 4, result["actions"].count 

    get '/api/v1/actions?circle=1', longitude: first_action.longitude, latitude: first_action.latitude, access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal 3, result["actions"].count 
  end

  test 'PUT api/v1/activities/:id with longitude and latitude also update action longitude, latitude' do
    create_activity(@current_user)

    activity = @current_user.activities.first
   
    put "api/v1/activities/#{activity.id}", 
        longitude: 122,
        latitude: 88,
        access_token: token

    assert last_response.ok?

    action = @current_user.actions.first
    assert_equal 122, action.longitude
    assert_equal 88, action.latitude
  end

  test "GET /api/v1/actions/of_user/:user_id returns the sepcified user's actions list" do
    create_activity(@gyb)
    create_living(@gyb)
    create_take_along_something(@gyb)

    get "/api/v1/actions/of_user/#{@gyb.id}", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal 3, result["actions"].count 
  end

  test "GET /api/v1/actions/of_user/:user_id?action_type=sponsor returns the sepcified user's sponsor actions list" do
    create_activity(@gyb)
    create_living(@gyb)
    create_take_along_something(@gyb)

    get "/api/v1/actions/of_user/#{@gyb.id}?action_type=sponsor", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal 2, result["actions"].count 
  end

  test "GET /api/v1/actions/of_user/:user_id?action_type=participant returns the sepcified user's participant actions list" do
    create_activity(@gyb)
    create_take_along_something(@gyb)

    get "/api/v1/actions/of_user/#{@gyb.id}?action_type=participant", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal 0, result["actions"].count 

    login_user(@gyb)

    activity = @gyb.activities.first
    take_along_something = @gyb.take_along_somethings.first

    put "api/v1/activities/#{activity.id}", 
        participations_attributes: [
          {user_id: @gyb.id},
          {user_id: @ww.id}
        ],
        access_token: token

    put "api/v1/take_along_somethings/#{take_along_something.id}", 
        order_take_attributes: { user_id: @gyb.id },
        access_token: token

    get "/api/v1/actions/of_user/#{@gyb.id}?action_type=participant", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal 2, result["actions"].count 

    get "/api/v1/actions/of_user/#{@ww.id}?action_type=participant", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal 1, result["actions"].count 

  end

  test "Delete a take along something should delete a action" do
    create_take_along_something(@gyb)

    get "/api/v1/actions/of_user/#{@gyb.id}", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal 1, result["actions"].count 

    login_user(@gyb)

    take_along_something = @gyb.take_along_somethings.first
    delete "api/v1/take_along_somethings/#{take_along_something.id}", 
      access_token: token

    get "/api/v1/actions/of_user/#{@gyb.id}", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "actions"
    assert_includes result, "paginate_meta"

    assert_equal 0, result["actions"].count 
  end

  test 'GET /api/v1/actions with max_distance returns a nearby actions list' do
    create_activity(@current_user)
    create_living(@gyb)
    create_take_along_something(@ww)

    get '/api/v1/actions', longitude: 33.5, latitude: 55.8, max_distance: 5,
        access_token: token

    assert last_response.ok?
  end

  private
    def with_user(user)
      login_user(user)
      yield
      login_user(@current_user)
    end

    def create_activity(user)
      with_user(user) do
        post "api/v1/activities", 
            title: "hello activity",
            price: 25.2,
            place: "example place",
            start_at: Time.current,
            end_at: 2.days.since,
            content: "example content",
            longitude: 112,
            latitude: 80,
            images_attributes: [
              {file: new_image_attachment},
              {file: new_image_attachment}
            ],
            access_token: token
      end
    end

    def create_living(user)
      with_user(user) do
        post "api/v1/livings", 
            title: "hello living",
            price: 25.2,
            place: "example place",
            content: "example content",
            longitude: 112,
            latitude: 80,
            videos_attributes: [
              {file: new_video_attachment},
              {file: new_video_attachment}
            ], 
            access_token: token
      end
    end

    def create_take_along_something(user)
      with_user(user) do
        post "api/v1/take_along_somethings", 
            title: "hello take_along_something",
            price: 25.2,
            place: "example place",
            start_at: Time.current,
            end_at: 2.days.since,
            content: "example content",
            longitude: 112,
            latitude: 80,
            sender_attributes: 
              {name: "gyb", phone: "11234234234", address: "24234234"} ,
            receiver_attributes: 
              {name: "ww", phone: "23423424", address: "112312311"} ,
            images_attributes: [
              {file: new_image_attachment},
              {file: new_image_attachment}
            ], 
            access_token: token
      end
    end
end
