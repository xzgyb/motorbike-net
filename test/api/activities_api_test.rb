require 'test_helper'

class ActivitiesApiTest < ActiveSupport::TestCase

  test 'GET /api/v1/activities returns a activities list' do
    create_list(:activity_with_images, 10)
    first_activity = Action.activity.first

    get '/api/v1/activities', longitude: first_activity.longitude, latitude: first_activity.latitude, access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "activities"
    assert_includes result, "paginate_meta"

    assert_equal Action.activity.count, result["activities"].count 
    
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

  test 'GET /api/v1/activities/:id returns a specified id activity' do
    activity = create(:activity_with_images)
    get "api/v1/activities/#{activity.id}", access_token: token
    
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "activity"
    assert_includes result["activity"], "content"
    assert_equal activity.id.to_s, result["activity"]["id"] 
  end

  test 'DELETE /api/v1/activities/:id should work' do
    activity = create(:activity_with_images)

    delete "api/v1/activities/#{activity.id}", access_token: token

    assert last_response.ok?
    assert_equal 0, Action.activity.count
  end

  test 'PUT /api/v1/activities/:id should update the specified id activity' do
    activity = create(:activity_with_images)

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
    assert_equal [112, 80], activity.coordinates 
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
    assert_equal 1, Action.activity.count

    activity = Action.activity.first
    assert_equal "hello activity", activity.title
    assert_equal 2, activity.images.count
  end

  def new_image_attachment
    Rack::Test::UploadedFile.new(Rails.root.join("test/files/sample.jpg"),
                                                 "image/jpeg")
  end

end
