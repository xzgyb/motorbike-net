require 'test_helper'

class LivingsApiTest < ActiveSupport::TestCase
  def setup
    @current_user = create(:user)
    @gyb = create(:user, name: 'gyb')

    login_user(@current_user)
  end

  test 'GET /api/v1/livings returns a livings list published by current_user and his friends' do
    create_friendship(@current_user, @gyb)

    create_list(:living_with_videos, 5, user: @current_user)
    create_list(:living_with_videos, 5, user: @gyb)
    create_list(:living_with_videos, 5, user: create(:user))
    
    first_living = @current_user.actions.livings.first

    get '/api/v1/livings', longitude: first_living.longitude, latitude: first_living.latitude, access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "livings"
    assert_includes result, "paginate_meta"

    assert_equal 10, result["livings"].count 
    
    %w[id title place price updated_at videos longitude latitude distance].each do |field|
      assert_includes result["livings"][0], field
    end

    assert_not_includes result["livings"][0], "content"

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end

    assert_equal 1, result["livings"][0]["videos"].count
    assert_includes result["livings"][0]["videos"][0], "url"
    assert_includes result["livings"][0]["videos"][0], "thumb_url"
  end

  test 'GET /api/v1/livings with max_distance returns a nearby livings list' do
    create_list(:living_with_videos, 10, coordinates:[33.5, 55.8], user: @current_user) 
    get '/api/v1/livings', longitude: 33.5, latitude: 55.8, max_distance: 5,
        access_token: token

    assert last_response.ok?
  end

  test 'GET /api/v1/livings/:id returns a specified id living' do
    living = create(:living_with_videos, user: @current_user)
    get "api/v1/livings/#{living.id}", access_token: token
    
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "living"
    assert_includes result["living"], "content"
    assert_equal living.id.to_s, result["living"]["id"] 
  end

  test 'DELETE /api/v1/livings/:id should work' do
    living = create(:living_with_videos, user: @current_user)

    delete "api/v1/livings/#{living.id}", access_token: token

    assert last_response.ok?
    assert_equal 0, @current_user.actions.livings.count
  end

  test 'PUT /api/v1/livings/:id should update the specified id living' do
    living = create(:living_with_videos, user: @current_user)

    put "api/v1/livings/#{living.id}", 
        title: "hello living",
        price: 25.2,
        content: "example content",
        longitude: 112,
        latitude: 80,
        videos_attributes: [
          {id: living.videos[0].id.to_s, file: new_video_attachment},
          {file: new_video_attachment},
          {file: new_video_attachment}
        ],
        access_token: token


    assert last_response.ok?

    living.reload

    assert_equal "hello living", living.title 
    assert_equal "25.2", living.price.to_s 
    assert_equal "example content", living.content 
    assert_equal [112, 80], living.coordinates 
    assert_equal 3, living.videos.count

    put "api/v1/livings/#{living.id}",
        videos_attributes: [
          {id: living.videos[0].id.to_s, _destroy: '1'}
        ],
        access_token: token
    assert last_response.ok?

    living.reload

    assert_equal 2, living.videos.count
    
  end

  test 'POST /api/v1/livings should create a living' do

    # login another user
    login_user @gyb

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

    # login current_user
    login_user @current_user

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

    assert last_response.created?
    assert_equal 1, @current_user.actions.livings.count

    living = @current_user.actions.livings.first
    assert_equal "hello living", living.title
    assert_equal 2, living.videos.count
  end

  def new_video_attachment
    Rack::Test::UploadedFile.new(Rails.root.join("test/files/sample.mp4"),
                                                 "video/mp4")
  end

end
