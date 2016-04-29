require 'test_helper'

class TakeAlongSomethingsApiTest < ActiveSupport::TestCase

  test 'GET /api/v1/take_along_somethings returns a take_along_somethings list' do
    create_list(:take_along_something_with_images, 10)

    first_take_along_something = Action.take_along_something.first

    get '/api/v1/take_along_somethings',
      longitude: first_take_along_something.longitude,
      latitude: first_take_along_something.latitude,
      access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "take_along_somethings"
    assert_includes result, "paginate_meta"

    assert_equal Action.take_along_something.count, result["take_along_somethings"].count 
    
    %w[id title place price updated_at start_at end_at images longitude latitude distance].each do |field|
      assert_includes result["take_along_somethings"][0], field
    end

    assert_not_includes result["take_along_somethings"][0], "content"

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end

    assert_equal 1, result["take_along_somethings"][0]["images"].count
    assert_includes result["take_along_somethings"][0]["images"][0], "url"
    assert_includes result["take_along_somethings"][0]["images"][0], "thumb_url"
  end

  test 'GET /api/v1/take_along_somethings/:id returns a specified id take_along_something' do
    take_along_something = create(:take_along_something_with_images)
    get "api/v1/take_along_somethings/#{take_along_something.id}", access_token: token
    
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "take_along_something"
    assert_includes result["take_along_something"], "content"
    assert_equal take_along_something.id.to_s, result["take_along_something"]["id"] 
  end

  test 'DELETE /api/v1/take_along_somethings/:id should work' do
    take_along_something = create(:take_along_something_with_images)

    delete "api/v1/take_along_somethings/#{take_along_something.id}", access_token: token

    assert last_response.ok?
    assert_equal 0, Action.take_along_something.count
  end

  test 'PUT /api/v1/take_along_somethings/:id should update the specified id take_along_something' do
    take_along_something = create(:take_along_something_with_images)

    put "api/v1/take_along_somethings/#{take_along_something.id}", 
        title: "hello take_along_something",
        price: 25.2,
        content: "example content",
        longitude: 112,
        latitude:  80,
        images_attributes: [
          {id: take_along_something.images[0].id.to_s, file: new_image_attachment},
          {file: new_image_attachment},
          {file: new_image_attachment}
        ], 
        access_token: token


    assert last_response.ok?

    take_along_something.reload

    assert_equal "hello take_along_something", take_along_something.title 
    assert_equal "25.2", take_along_something.price.to_s 
    assert_equal "example content", take_along_something.content 
    assert_equal [112, 80], take_along_something.coordinates 
    assert_equal 3, take_along_something.images.count

    put "api/v1/take_along_somethings/#{take_along_something.id}",
        images_attributes: [
          {id: take_along_something.images[0].id.to_s, _destroy: '1'}
        ],
        access_token: token
    assert last_response.ok?

    take_along_something.reload

    assert_equal 2, take_along_something.images.count
    
  end

  test 'POST /api/v1/take_along_somethings should create a take_along_something' do

    post "api/v1/take_along_somethings", 
        title: "hello take_along_something",
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
    assert_equal 1, Action.take_along_something.count

    take_along_something = Action.take_along_something.first
    assert_equal "hello take_along_something", take_along_something.title
    assert_equal 2, take_along_something.images.count
  end

  def new_image_attachment
    Rack::Test::UploadedFile.new(Rails.root.join("test/files/sample.jpg"),
                                                 "image/jpeg")
  end

end
