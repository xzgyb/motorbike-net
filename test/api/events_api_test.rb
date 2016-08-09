require 'test_helper'

class EventsApiTest < ActiveSupport::TestCase
  def setup
    @current_user = create(:user)
    login_user(@current_user)
  end

  test 'creating a action should create a event for current user' do
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

    post "api/v1/take_along_somethings", 
        title: "hello take_along_something",
        price: 25.2,
        place: "example place",
        start_at: Time.current,
        end_at: 2.days.since,
        content: "example content",
        longitude: 112,
        latitude: 80,
        sender_attributes: {name: "gyb", phone: "11234234234", address: "24234234"} ,
        receiver_attributes: {name: "ww", phone: "23423424", address: "112312311"} ,
        images_attributes: [
          {file: new_image_attachment},
          {file: new_image_attachment}
        ], 
        access_token: token

    get "/api/v1/events", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "events"
    assert_includes result, "paginate_meta"

    assert_equal 3, result["events"].count 

    %w[id title content place start_at end_at longitude latitude image_url type].each do |field|
      assert_includes result["events"][0], field
    end

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end
  end

  test 'deleting a action should delete a event for current user' do
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

    assert last_response.created?

    get "api/v1/activities", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)
    id = result["activities"][0]["id"]

    delete "api/v1/activities/#{id}", access_token: token
    assert last_response.ok?
    get "/api/v1/events", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 0, result["events"].count 

  end


  test 'POST /api/v1/events should create a event' do
    post "api/v1/events", 
        title: "hello event",
        place: "example place",
        start_at: Time.current,
        end_at: 2.days.since,
        content: "example content",
        longitude: 112,
        latitude: 80,
        access_token: token

    assert last_response.created?

    get "api/v1/events", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 1, result["events"].count
    assert_equal 3, result["events"][0]["type"] 
  end

  test 'GET /api/v1/events/:id returns a specified id event' do
    event = create(:event, user: @current_user)
    get "api/v1/events/#{event.id}", access_token: token
    
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "event"
    assert_includes result["event"], "content"
    assert_equal event.id, result["event"]["id"] 
  end

  test 'DELETE /api/v1/events/:id should work' do
    event = create(:event, user: @current_user)

    delete "api/v1/events/#{event.id}", access_token: token

    assert last_response.ok?
    assert_equal 0, @current_user.events.count
  end

  test 'PUT /api/v1/events/:id should update the specified id event' do
    event = create(:event, user: @current_user)

    put "api/v1/events/#{event.id}", 
        title: "hello hello",
        price: 25.2,
        content: "example content",
        longitude: 112,
        latitude: 80,
        access_token: token

    assert last_response.ok?

    event.reload

    assert_equal "hello hello", event.title 
  end

  test "GET /api/v1/events with start_at param returns a events list which's start time is after the specified start_at param" do
    create(:event, start_at: Time.current, user: @current_user)
    create(:event, start_at: 1.days.since, user: @current_user)
    create(:event, start_at: 2.days.since, user: @current_user)
    create(:event, start_at: 3.days.since, user: @current_user)

    get '/api/v1/events', start_at: 1.days.since, access_token: token

    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "events"
    assert_equal 3, result["events"].count
  end

  def new_image_attachment
    Rack::Test::UploadedFile.new(Rails.root.join("test/files/sample.jpg"),
                                                 "image/jpeg")
  end
  
  def new_video_attachment
    Rack::Test::UploadedFile.new(Rails.root.join("test/files/sample.mp4"),
                                                 "video/mp4")
  end
end
