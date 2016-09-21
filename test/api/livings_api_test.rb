require 'test_helper'

class LivingsApiTest < ActiveSupport::TestCase
  def setup
    @current_user = create(:user)

    @gyb = create(:user, name: 'gyb')
    @john  = create(:user, name: 'john')
    @peter = create(:user, name: 'peter')
    @mike  = create(:user, name: 'mike')

    login_user(@current_user)
  end

  test 'GET /api/v1/livings returns a livings list published by current_user and his friends' do
    create_friendship(@current_user, @gyb)

    create_list(:living_with_videos_images, 5, user: @current_user)
    create_list(:living_with_videos_images, 5, user: @gyb)
    create_list(:living_with_videos_images, 5, user: create(:user))
    
    first_living = @current_user.livings.first

    get '/api/v1/livings', longitude: first_living.longitude, latitude: first_living.latitude, access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "livings"
    assert_includes result, "paginate_meta"

    assert_equal 15, result["livings"].count 

    get '/api/v1/livings?circle=1', longitude: first_living.longitude, latitude: first_living.latitude, access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "livings"
    assert_includes result, "paginate_meta"

    assert_equal 10, result["livings"].count 
    
    %w[id title place price updated_at videos images longitude latitude distance].each do |field|
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

  test "GET /api/v1/livings/of_user/:user_id returns the sepcified user's livings list" do
    create_list(:living_with_videos_images, 5, user: @gyb)

    get "/api/v1/livings/of_user/#{@gyb.id}", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "livings"
    assert_includes result, "paginate_meta"

    assert_equal 5, result["livings"].count 
  end

  test 'GET /api/v1/livings with max_distance returns a nearby livings list' do
    create_list(:living_with_videos_images, 10, longitude: 33.5, latitude: 55.8, user: @current_user) 
    get '/api/v1/livings', longitude: 33.5, latitude: 55.8, max_distance: 5,
        access_token: token

    assert last_response.ok?
  end

  test 'GET /api/v1/livings/:id returns a specified id living' do
    living = create(:living_with_videos_images, user: @current_user)
    get "api/v1/livings/#{living.id}", access_token: token
    
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "living"
    assert_includes result["living"], "content"
    assert_equal living.id, result["living"]["id"] 
  end

  test 'DELETE /api/v1/livings/:id should work' do
    living = create(:living_with_videos_images, user: @current_user)

    delete "api/v1/livings/#{living.id}", access_token: token

    assert last_response.ok?
    assert_equal 0, @current_user.livings.count
  end

  test 'PUT /api/v1/livings/:id should update the specified id living' do
    living = create(:living_with_videos_images, user: @current_user)

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
    assert_equal 112, living.longitude 
    assert_equal 80, living.latitude 
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
        images_attributes: [
          {file: new_image_attachment},
          {file: new_image_attachment}
        ], 
        access_token: token

    assert last_response.created?
    assert_equal 1, @current_user.livings.count

    living = @current_user.livings.first
    assert_equal "hello living", living.title
    assert_equal 2, living.videos.count
  end

  test 'DELETE /api/v1/livings/reset should work' do
    create_list(:living_with_videos_images, 5, user: @current_user)

    delete "api/v1/livings/reset", access_token: token

    assert last_response.ok?
    assert_equal 0, @current_user.livings.count
  end

  test 'POST /api/v1/livings/:id/likes should work' do
    living = create(:living_with_videos_images, user: @current_user)

    create_like(living, @gyb)
    create_like(living, @john)
    create_like(living, @peter)
    create_like(living, @mike)

    assert_equal 4, living.likes.count 
  end

  test 'POST /api/v1/livings/:id/likes repeatedly should create a like only' do
    living = create(:living_with_videos_images, user: @current_user)

    create_like(living, @gyb)
    create_like(living, @gyb)
    create_like(living, @gyb)

    assert_equal 1, living.likes.count 
    assert_equal @gyb, living.likes.first.user
  end

  test 'GET /api/v1/livings/:id/likes should work' do
    living = create(:living_with_videos_images, user: @current_user)

    create_like(living, @gyb)
    create_like(living, @john)
    create_like(living, @peter)
    create_like(living, @mike)
    
    get "api/v1/livings/#{living.id}/likes", 
         access_token: token

    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "likes"
    assert_includes result, "paginate_meta"

    assert_equal 4, result["likes"].count 

    %w[id user_id user_name].each do |field|
      assert_includes result["likes"][0], field
    end

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end

  end

  test 'DELETE /api/v1/livings/likes/:id should work' do
    living = create(:living_with_videos_images, user: @current_user)

    create_like(living, @gyb)
   
    login_user(@gyb) 

    delete "api/v1/livings/likes/#{living.likes.first.id}", 
            access_token: token

    login_user(@current_user)

    assert last_response.ok?

    assert_equal 0, living.likes.count 
  end

  test 'POST /api/v1/livings/:id/comments should work' do
    living = create(:living_with_videos_images, user: @current_user)

    create_comment(living, @gyb)
    create_comment(living, @john)
    create_comment(living, @peter)
    create_comment(living, @mike)

    assert_equal 4, living.comments.count 
  end

  test 'GET /api/v1/livings/:id/comments should work' do
    living = create(:living_with_videos_images, user: @current_user)

    create_comment(living, @gyb)
    create_comment(living, @john)
    create_comment(living, @peter)
    create_comment(living, @mike)
    
    get "api/v1/livings/#{living.id}/comments", 
         access_token: token

    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result, "comments"
    assert_includes result, "paginate_meta"

    assert_equal 4, result["comments"].count 

    %w[id user_id user_name content].each do |field|
      assert_includes result["comments"][0], field
    end

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end

  end

  test 'DELETE /api/v1/livings/comments/:id should work' do
    living = create(:living_with_videos_images, user: @current_user)

    create_comment(living, @gyb)
   
    login_user(@gyb) 

    delete "api/v1/livings/comments/#{living.comments.first.id}", 
            access_token: token

    login_user(@current_user)

    assert last_response.ok?

    assert_equal 0, living.comments.count 
  end

  test 'POST /api/v1/livings/:id/comments with reply_to_user_id should work' do
    living = create(:living_with_videos_images, user: @current_user)

    create_comment(living, @gyb)
    create_comment(living, @john, @gyb)
    create_comment(living, @gyb, @john)

    assert_equal 3, living.comments.count 

    get "api/v1/livings/#{living.id}/comments", 
         access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 3, result["comments"].count 

    %w[reply_to_user_id reply_to_user_name].each do |field|
      assert_not_includes result["comments"][0], field
    end

    %w[reply_to_user_id reply_to_user_name].each do |field|
      assert_includes result["comments"][1], field
      assert_includes result["comments"][2], field
    end
  end

  test 'GET /api/v1/livings should get a livings list which contains likes and comments when create likes and comments' do
    living = create(:living_with_videos_images, user: @current_user)

    create_like(living, @gyb)
    create_like(living, @john)
    create_like(living, @peter)
    create_like(living, @mike)

    create_comment(living, @gyb)
    create_comment(living, @john, @gyb)
    create_comment(living, @gyb, @john)
    
    get "api/v1/livings", access_token: token

    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert_includes result["livings"][0], "likes"
    assert_includes result["livings"][0], "total_likes_count"

    assert_equal 4, result["livings"][0]["likes"].count 
    assert_equal 4, result["livings"][0]["total_likes_count"]

    %w[id user_id user_name].each do |field|
      assert_includes result["livings"][0]["likes"][0], field
    end

    assert_includes result["livings"][0], "comments"
    assert_includes result["livings"][0], "total_comments_count"

    assert_equal 3, result["livings"][0]["comments"].count 
    assert_equal 3, result["livings"][0]["total_comments_count"]

    %w[id user_id user_name content].each do |field|
      assert_includes result["livings"][0]["comments"][0], field
    end
  end

  private
    def create_like(living, user)
      login_user(user)

      post "api/v1/livings/#{living.id}/likes", 
           access_token: token
      assert last_response.created?

      login_user(@current_user)
    end

    def create_comment(living, user, reply_to_user = nil)
      login_user(user)

      if reply_to_user
        post "api/v1/livings/#{living.id}/comments", 
             content: "hello",
             reply_to_user_id: reply_to_user.id,
             access_token: token
      else
        post "api/v1/livings/#{living.id}/comments", 
             content: "hello",
             access_token: token
      end

      assert last_response.created?

      login_user(@current_user)
    end
end
