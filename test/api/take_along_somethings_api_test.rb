require 'test_helper'

class TakeAlongSomethingsApiTest < ActiveSupport::TestCase
  def setup
    @current_user = create(:user)
    @gyb = create(:user, name: 'gyb')
    @gg  = create(:user, name: 'gg')

    login_user(@current_user)
  end

  test 'GET /api/v1/take_along_somethings returns a take_along_somethings list published by current_user and his friends' do
    create_friendship(@current_user, @gyb)

    create_list(:take_along_something_with_images, 5, user: @current_user)
    create_list(:take_along_something_with_images, 5, user: @gyb)
    create_list(:take_along_something_with_images, 5, user: create(:user))

    first_take_along_something = @current_user.take_along_somethings.first

    get '/api/v1/take_along_somethings',
      longitude: first_take_along_something.longitude,
      latitude: first_take_along_something.latitude,
      access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "take_along_somethings"
    assert_includes result, "paginate_meta"

    assert_equal 15, result["take_along_somethings"].count 

    get '/api/v1/take_along_somethings?circle=1',
      longitude: first_take_along_something.longitude,
      latitude: first_take_along_something.latitude,
      access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "take_along_somethings"
    assert_includes result, "paginate_meta"

    assert_equal 10, result["take_along_somethings"].count 
   
    %w[id title place price updated_at start_at end_at images longitude latitude distance sender receiver].each do |field|
      assert_includes result["take_along_somethings"][0], field
    end

    %w[name address phone longitude latitude place].each do |field|
      assert_includes result["take_along_somethings"][0]["sender"], field
    end

    %w[name address phone longitude latitude place].each do |field|
      assert_includes result["take_along_somethings"][0]["receiver"], field
    end

    assert_not_includes result["take_along_somethings"][0], "content"

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end

    assert_equal 1, result["take_along_somethings"][0]["images"].count
    assert_includes result["take_along_somethings"][0]["images"][0], "url"
    assert_includes result["take_along_somethings"][0]["images"][0], "thumb_url"
  end

  test "GET /api/v1/take_along_somethings/of_user/:user_id returns the sepcified user's take along somethings list" do
    create_list(:take_along_something_with_images, 5, user: @gyb)

    get "/api/v1/take_along_somethings/of_user/#{@gyb.id}", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "take_along_somethings"
    assert_includes result, "paginate_meta"

    assert_equal 5, result["take_along_somethings"].count 
  end

  test 'GET /api/v1/take_along_somethings with max_distance returns a nearby take_along_something list' do
    create_list(:take_along_something_with_images, 10, longitude: 33.5, latitude:55.8, user: @current_user) 

    get '/api/v1/take_along_somethings', longitude: 33.5, latitude: 55.8, max_distance: 5,
        access_token: token

    assert last_response.ok?
  end

  test 'GET /api/v1/take_along_somethings returns a take_along_something list when create record without images' do
    create_list(:take_along_something, 10, longitude: 33.5, latitude: 55.8, user: @current_user) 

    get '/api/v1/take_along_somethings', access_token: token
    
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "take_along_somethings"
    assert_includes result, "paginate_meta"

    assert_equal 10, result["take_along_somethings"].count 

    assert last_response.ok?
  end

  test 'GET /api/v1/take_along_somethings/:id returns a specified id take_along_something' do
    take_along_something = create(:take_along_something_with_images, user: @current_user)
    get "api/v1/take_along_somethings/#{take_along_something.id}", access_token: token
    
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "take_along_something"
    assert_includes result["take_along_something"], "content"
    assert_equal take_along_something.id, result["take_along_something"]["id"] 
  end

  test 'DELETE /api/v1/take_along_somethings/:id should work' do
    take_along_something = create(:take_along_something_with_images, user: @current_user)

    delete "api/v1/take_along_somethings/#{take_along_something.id}", access_token: token

    assert last_response.ok?
    assert_equal 0, @current_user.take_along_somethings.count
  end

  test 'PUT /api/v1/take_along_somethings/:id should update the specified id take_along_something' do
    take_along_something = create(:take_along_something_with_images, user: @current_user)

    put "api/v1/take_along_somethings/#{take_along_something.id}", 
        title: "hello take_along_something",
        price: 25.2,
        content: "example content",
        longitude: 112,
        latitude:  80,
        sender_attributes: {name: "qwwqe", phone: "11234234234", address: "24234234"} ,
        receiver_attributes: {name: "weras", phone: "23423424", address: "112312311"} ,
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
    assert_equal 112, take_along_something.longitude 
    assert_equal 80, take_along_something.latitude 
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

    # login another user
    login_user @gyb

    post "api/v1/take_along_somethings", 
        title: "hello take_along_something",
        price: 25.2,
        place: "example place",
        start_at: Time.current,
        end_at: 2.days.since,
        content: "example content",
        longitude: 112,
        latitude: 80,
        sender_attributes: {name: "gyb", 
                            phone: "11234234234",
                            address: "24234234",
                            place: "sender place",
                            longitude: 110,
                            latitude: 75} ,
        receiver_attributes: {name: "ww", 
                              phone: "23423424", 
                              address: "112312311",
                              place: "receiver place",
                              longitude: 110,
                              latitude: 75}, 
        images_attributes: [
          {file: new_image_attachment},
          {file: new_image_attachment}
        ], 
        access_token: token

    # login current_user
    login_user @current_user

    post "api/v1/take_along_somethings", 
        title: "hello take_along_something",
        price: 25.2,
        place: "example place",
        start_at: Time.current,
        end_at: 2.days.since,
        content: "example content",
        longitude: 112,
        latitude: 80,
        sender_attributes: {name: "gyb",
                            phone: "11234234234", 
                            address: "24234234",
                            place: "sender place",
                            longitude: 110,
                            latitude: 75},
        receiver_attributes: {name: "ww", 
                              phone: "23423424", 
                              address: "112312311",
                              place: "receiver place",
                              longitude: 110,
                              latitude: 75}, 
        images_attributes: [
          {file: new_image_attachment},
          {file: new_image_attachment}
        ], 
        access_token: token

    assert last_response.created?
    assert_equal 1, @current_user.take_along_somethings.count

    take_along_something = @current_user.take_along_somethings.first
    assert_equal "hello take_along_something", take_along_something.title
    assert_equal 2, take_along_something.images.count
  end

  test 'POST /api/v1/take_along_somethings with order taker should create a take along something' do
    post "api/v1/take_along_somethings", 
        title: "hello take_along_something",
        price: 25.2,
        place: "example place",
        start_at: Time.current,
        end_at: 2.days.since,
        content: "example content",
        longitude: 112,
        latitude: 80,
        sender_attributes: {name: "gyb",
                            phone: "11234234234", 
                            address: "24234234",
                            place: "sender place",
                            longitude: 110,
                            latitude: 75},
        receiver_attributes: {name: "ww", 
                              phone: "23423424", 
                              address: "112312311",
                              place: "receiver place",
                              longitude: 110,
                              latitude: 75}, 
        order_take_attributes: { user_id: @gyb.id },
        images_attributes: [
          {file: new_image_attachment},
          {file: new_image_attachment}
        ], 
        access_token: token

    assert last_response.created?
    assert @current_user.take_along_somethings.first.order_taker
    assert_equal @gyb, @current_user.take_along_somethings.first.order_taker
  end

  test 'PUT /api/v1/take_along_somethings/:id with order taker should update the specified id take along something' do
    take_along_something = create(:take_along_something_with_images, user: @current_user)

    put "api/v1/take_along_somethings/#{take_along_something.id}", 
        order_take_attributes: { user_id: @gyb.id },
        access_token: token


    assert last_response.ok?

    take_along_something.reload

    assert_equal @gyb, take_along_something.order_taker

    put "api/v1/take_along_somethings/#{take_along_something.id}", 
        order_take_attributes: { user_id: @gg.id },
        access_token: token

    assert last_response.ok?

    take_along_something.reload

    assert_equal @gg, take_along_something.order_taker
  end

  test 'PUT /api/v1/take_along_somethings/:id/take_order should take the specified id take_along_something order' do
    take_along_something = create(:take_along_something_with_images, user: @current_user)

    login_user(@gyb)

    put "api/v1/take_along_somethings/#{take_along_something.id}/take_order",
        access_token: token
    assert last_response.ok?

    login_user(@gg)

    put "api/v1/take_along_somethings/#{take_along_something.id}/take_order",
        access_token: token
    assert last_response.ok?

    take_along_something.reload

    assert_equal @gg, take_along_something.order_taker
  end

  test 'PUT /api/v1/take_along_somethings/:id/take_order should work oneself' do
    take_along_something = create(:take_along_something_with_images, user: @current_user)

    put "api/v1/take_along_somethings/#{take_along_something.id}/take_order",
        access_token: token
    assert last_response.ok?

    assert_equal @current_user, take_along_something.reload.order_taker
  end

  test 'GET /api/v1/take_along_somethings/:id returns a specified id take along something with order taker' do
    post "api/v1/take_along_somethings", 
        title: "hello take_along_something",
        price: 25.2,
        place: "example place",
        start_at: Time.current,
        end_at: 2.days.since,
        content: "example content",
        longitude: 112,
        latitude: 80,
        sender_attributes: {name: "gyb",
                            phone: "11234234234", 
                            address: "24234234",
                            place: "sender place",
                            longitude: 110,
                            latitude: 75},
        receiver_attributes: {name: "ww", 
                              phone: "23423424", 
                              address: "112312311",
                              place: "receiver place",
                              longitude: 110,
                              latitude: 75}, 
        order_take_attributes: { user_id: @gyb.id },
        images_attributes: [
          {file: new_image_attachment},
          {file: new_image_attachment}
        ], 
        access_token: token

    assert last_response.created?

    take_along_something = @current_user.take_along_somethings.first

    get "api/v1/take_along_somethings/#{take_along_something.id}", access_token: token
    
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "take_along_something"
    assert_includes result["take_along_something"], "content"
    assert_includes result["take_along_something"], "order_take"
    assert result["take_along_something"]["order_take"]

    %w[id user_id user_name user_avatar_url].each do |field|
      assert_includes result["take_along_something"]["order_take"], field
    end

    assert_equal take_along_something.id, result["take_along_something"]["id"] 
  end

  test 'DELETE /api/v1/take_along_somethings/reset should work' do
    create_list(:take_along_something_with_images, 5, user: @current_user)

    delete "api/v1/take_along_somethings/reset", access_token: token

    assert last_response.ok?
    assert_equal 0, @current_user.take_along_somethings.count
  end
end
