require 'test_helper'

class ActivitiesApiTest < ActiveSupport::TestCase
  def setup
    @current_user = create(:user)
    @gyb = create(:user, name: 'gyb')
    @ww  = create(:user, name: 'ww')
    @gg  = create(:user, name: 'gg')

    login_user(@current_user)
  end

  test 'GET /api/v1/activities returns a activities list published by current_user and his friends' do
    create_friendship(@current_user, @gyb)

    create_list(:activity_with_images, 5, user: @current_user)
    create_list(:activity_with_images, 5, user: @gyb)
    create_list(:activity_with_images, 5, user: create(:user))

    first_activity = @current_user.activities.first

    get '/api/v1/activities', longitude: first_activity.longitude, latitude: first_activity.latitude, access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "activities"
    assert_includes result, "paginate_meta"

    assert_equal 10, result["activities"].count

    %w[id title place price updated_at start_at end_at images longitude latitude distance].each do |field|
      assert_includes result["activities"][0], field
    end

    assert_not_includes result["activities"][0], "content"

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end

    assert_equal 1, result["activities"][0]["images"].count
    assert_includes result["activities"][0]["images"][0], "url"
    assert_includes result["activities"][0]["images"][0], "thumb_url"
  end

  test "GET /api/v1/activities/of_user/:user_id returns the sepcified user's activities list" do
    create_list(:activity_with_images, 5, user: @gyb)

    get "/api/v1/activities/of_user/#{@gyb.id}", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "activities"
    assert_includes result, "paginate_meta"

    assert_equal 5, result["activities"].count 
  end

  test 'GET /api/v1/activities with max_distance returns a nearby activities list' do
    create_list(:activity_with_images, 10, longitude: 33.5, latitude:55.8, user: @current_user) 
    get '/api/v1/activities', longitude: 33.5, latitude: 55.8, max_distance: 5,
        access_token: token

    assert last_response.ok?
  end

  test 'GET /api/v1/activities/:id returns a specified id activity' do
    activity = create(:activity_with_images, user: @current_user)
    get "api/v1/activities/#{activity.id}", access_token: token
    
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "activity"
    assert_includes result["activity"], "content"
    assert_equal activity.id, result["activity"]["id"] 
  end

  test 'DELETE /api/v1/activities/:id should work' do
    activity = create(:activity_with_images, user: @current_user)

    delete "api/v1/activities/#{activity.id}", access_token: token

    assert last_response.ok?
    assert_equal 0, @current_user.activities.count
  end

  test 'PUT /api/v1/activities/:id should update the specified id activity' do
    activity = create(:activity_with_images, user: @current_user)

    put "api/v1/activities/#{activity.id}", 
        title: "hello activity",
        price: 25.2,
        content: "example content",
        longitude: 112,
        latitude: 80,
        images_attributes: [
          {id: activity.images[0].id.to_s, file: new_image_attachment},
          {file: new_image_attachment},
          {file: new_image_attachment}
        ],
        access_token: token


    assert last_response.ok?

    activity.reload

    assert_equal "hello activity", activity.title 
    assert_equal "25.2", activity.price.to_s 
    assert_equal "example content", activity.content 
    assert_equal 112, activity.longitude 
    assert_equal 80, activity.latitude 
    assert_equal 3, activity.images.count

    put "api/v1/activities/#{activity.id}",
        images_attributes: [
          {id: activity.images[0].id.to_s, _destroy: '1'}
        ],
        access_token: token
    assert last_response.ok?

    activity.reload

    assert_equal 2, activity.images.count
    
  end

  test 'POST /api/v1/activities should create a activity' do
    # login another user
    login_user @gyb

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

    # login current_user
    login_user @current_user

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
    assert_equal 1, @current_user.activities.count

    activity = @current_user.activities.first
    assert_equal "hello activity", activity.title
    assert_equal 2, activity.images.count
  end

  test 'POST /api/v1/activities with participations should create a activity' do
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
        participations_attributes: [
          {user_id: @gyb.id},
          {user_id: @ww.id}
        ],
        access_token: token

    assert last_response.created?
    assert_equal 2, @current_user.activities.first.participators.count
    assert_equal @gyb, @current_user.activities.first.participators[0]
    assert_equal @ww, @current_user.activities.first.participators[1]

  end

  test 'PUT /api/v1/activities/:id with participations should update the specified id activity' do
    activity = create(:activity_with_images, user: @current_user)

    put "api/v1/activities/#{activity.id}", 
        participations_attributes: [
          {user_id: @gyb.id},
          {user_id: @ww.id}
        ],
        access_token: token


    assert last_response.ok?

    activity.reload

    assert_equal 2, activity.participators.count
    assert_equal @gyb, activity.participators[0]
    assert_equal @ww, activity.participators[1]

    put "api/v1/activities/#{activity.id}", 
        participations_attributes: [
          {user_id: @gg.id}
        ],
        access_token: token

    assert last_response.ok?

    activity.reload

    assert_equal 3, activity.participators.count

    assert_equal @gyb, activity.participators[0]
    assert_equal @ww, activity.participators[1]
    assert_equal @gg, activity.participators[2]

    put "api/v1/activities/#{activity.id}",
         participations_attributes: [
          {id: activity.participations[0].id, _destroy: '1'}
        ],
        access_token: token
    assert last_response.ok?

    activity.reload
    assert_equal 2, activity.participators.count

  end

  test 'PUT /api/v1/activities/:id/participate should participate the specified id activity' do
    activity = create(:activity_with_images, user: @current_user)

    login_user(@gyb)

    put "api/v1/activities/#{activity.id}/participate",
        access_token: token
    assert last_response.ok?

    login_user(@ww)

    put "api/v1/activities/#{activity.id}/participate",
        access_token: token
    assert last_response.ok?

    
    activity.reload

    assert_equal 2, activity.participators.count
    assert_equal @gyb, activity.participators[0]
    assert_equal @ww, activity.participators[1]
  end

  test 'GET /api/v1/activities/:id returns a specified id activity with participators' do
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
        participations_attributes: [
          {user_id: @gyb.id},
          {user_id: @ww.id}
        ],
        access_token: token

    assert last_response.created?

    activity = @current_user.activities.first

    get "api/v1/activities/#{activity.id}", access_token: token
    
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "activity"
    assert_includes result["activity"], "content"
    assert_includes result["activity"], "participations"
    assert_includes result["activity"], "organizer"

    assert_equal activity.id, result["activity"]["id"] 
    assert_equal 2, result["activity"]["participations"].count

    %w[id user_id user_name user_avatar_url].each do |field|
      assert_includes result["activity"]["participations"][0], field
    end
  end

  test 'DELETE /api/v1/activities/reset should work' do
    create_list(:activity_with_images, 5, user: @current_user)

    delete "api/v1/activities/reset", access_token: token

    assert last_response.ok?
    assert_equal 0, @current_user.activities.count
  end

end
