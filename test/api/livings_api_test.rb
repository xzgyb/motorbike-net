require 'test_helper'

class LivingsApiTest < ActiveSupport::TestCase
  include Rack::Test::Methods  

  def app; Rails.application; end

  test 'GET /api/v1/livings returns a livings list' do
    create_list(:living_with_videos, 10)
    get '/api/v1/livings'

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "livings"
    assert_includes result, "paginate_meta"

    assert_equal Action.living.count, result["livings"].count 
    
    %w[id title place price updated_at videos longitude latitude].each do |field|
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

  test 'GET /api/v1/livings returns a livings list the order of which is descendant by updated_at' do
    one = create(:living_with_videos, updated_at: Time.current)
    two = create(:living_with_videos, updated_at: 1.day.since)
    three = create(:living_with_videos, updated_at: 2.days.since)

    get 'api/v1/livings'
    
    result = JSON.parse(last_response.body)

    result_ids = result["livings"].map { |elem| elem["id"] }
    assert_equal [three.id.to_s, two.id.to_s, one.id.to_s], result_ids 

  end

  test 'GET /api/v1/livings/:id returns a specified id living' do
    living = create(:living_with_videos)
    get "api/v1/livings/#{living.id}"
    
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "living"
    assert_includes result["living"], "content"
    assert_equal living.id.to_s, result["living"]["id"] 
  end

  test 'DELETE /api/v1/livings/:id should work' do
    living = create(:living_with_videos)

    delete "api/v1/livings/#{living.id}"

    assert last_response.ok?
    assert_equal 0, Action.living.count
  end

  test 'PUT /api/v1/livings/:id should update the specified id living' do
    living = create(:living_with_videos)

    put "api/v1/livings/#{living.id}", 
        title: "hello living",
        price: 25.2,
        content: "example content",
        longitude: 112,
        latitude: 553,
        videos_attributes: [
          {id: living.videos[0].id.to_s, file: new_video_attachment},
          {file: new_video_attachment},
          {file: new_video_attachment}
        ]


    assert last_response.ok?

    living.reload

    assert_equal "hello living", living.title 
    assert_equal "25.2", living.price.to_s 
    assert_equal "example content", living.content 
    assert_equal [112, 553], living.coordinates 
    assert_equal 3, living.videos.count

    put "api/v1/livings/#{living.id}",
        videos_attributes: [
          {id: living.videos[0].id.to_s, _destroy: '1'}
        ]
    assert last_response.ok?

    living.reload

    assert_equal 2, living.videos.count
    
  end

  test 'POST /api/v1/livings should create a living' do

    post "api/v1/livings", 
        title: "hello living",
        price: 25.2,
        place: "example place",
        content: "example content",
        longitude: 112,
        latitude: 553,
        videos_attributes: [
          {file: new_video_attachment},
          {file: new_video_attachment}
        ]

    assert last_response.created?
    assert_equal 1, Action.living.count

    living = Action.living.first
    assert_equal "hello living", living.title
    assert_equal 2, living.videos.count
  end

  def new_video_attachment
    Rack::Test::UploadedFile.new(Rails.root.join("test/files/sample.mp4"),
                                                 "video/mp4")
  end

end
