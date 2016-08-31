require 'test_helper'

class MessagesApiTest < ActiveSupport::TestCase
  def setup
    @gyb = create(:user, name: 'gyb')
    @current_user = @gyb

    login_user(@gyb)

    @john  = create(:user, name: 'john')
    @peter = create(:user, name: 'peter')
    @mike  = create(:user, name: 'mike')
    @david = create(:user, name: 'david')
  end

  test 'Add a friend request for current user should create a friend request message for the friend' do
    create_add_friend_request(@john)

    assert_equal 1, @john.messages.unread.count

    login_user(@john)

    get '/api/v1/messages', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "messages"
    assert_includes result, "paginate_meta"

    %w[is_read message_type friendship].each do |field|
      assert_includes result["messages"][0], field
    end

    %w[friend_id friend_name friend_avatar_url accepted].each do |field|
      assert_includes result["messages"][0]["friendship"], field
    end
  end

  test "Joining a activity should create a message for the activity's sponsor" do
    create_activity_participation_request(@john)

    assert_equal 1, @current_user.messages.unread.count

    get '/api/v1/messages', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "messages"
    assert_includes result, "paginate_meta"

    %w[is_read message_type participation].each do |field|
      assert_includes result["messages"][0], field
    end

    %w[id user_id user_name user_avatar_url].each do |field|
      assert_includes result["messages"][0]["participation"], field
    end
  end

  test "Taking a take_along_something order should create a message for the take_along_something's sponsor" do
    create_take_along_something_order_take_request(@john)

    assert_equal 1, @current_user.messages.unread.count

    get '/api/v1/messages', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "messages"
    assert_includes result, "paginate_meta"

    %w[is_read message_type order_take].each do |field|
      assert_includes result["messages"][0], field
    end

    %w[id user_id user_name user_avatar_url].each do |field|
      assert_includes result["messages"][0]["order_take"], field
    end
  end

  test "PUT /api/v1/messages/mark_as_read should work" do
    login_user(@john)
    create_add_friend_request(@current_user)
    login_user(@current_user)

    create_activity_participation_request(@john)
    create_take_along_something_order_take_request(@john)

    assert_equal 3, @current_user.messages.unread.count

    put '/api/v1/messages/mark_as_read', access_token: token
    assert last_response.ok?

    assert_equal 0, @current_user.messages.unread.count

    get '/api/v1/messages', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)
    assert_equal 3, result['messages'].count

    assert_equal 1, result['messages'][0]['is_read']
    assert_equal 1, result['messages'][1]['is_read']
    assert_equal 1, result['messages'][2]['is_read']
  end

  test "all messages should work" do
    login_user(@john)
    create_add_friend_request(@current_user)
    login_user(@current_user)

    create_activity_participation_request(@john)
    create_take_along_something_order_take_request(@john)

    assert_equal 3, @current_user.messages.unread.count

    get '/api/v1/messages', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "messages"
    assert_includes result, "paginate_meta"

    assert_equal 3, result['messages'].count

    assert_equal 2, result['messages'][0]['message_type']
    assert_equal 1, result['messages'][1]['message_type']
    assert_equal 0, result['messages'][2]['message_type']
  end

  test "GET /api/v1/messages/unread_count should work" do
    login_user(@john)
    create_add_friend_request(@current_user)
    login_user(@current_user)

    create_activity_participation_request(@john)
    create_take_along_something_order_take_request(@john)

    get '/api/v1/messages/unread_count', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "messages"
    assert_equal 3, result["messages"]["unread_count"]
  end

  def create_add_friend_request(user)
    post '/api/v1/friends', access_token: token, friend_id: user.id
    assert last_response.created?
  end

  def create_activity_participation_request(user)
    activity = create(:activity_with_images, user: @current_user)

    login_user(user)

    put "api/v1/activities/#{activity.id}/participate", 
        access_token: token

    assert last_response.ok?

    login_user(@current_user)
  end

  def create_take_along_something_order_take_request(user)
    take_along_something = create(:take_along_something_with_images, 
                                  user: @current_user)

    login_user(user)

    put "api/v1/take_along_somethings/#{take_along_something.id}/take_order", 
        access_token: token

    assert last_response.ok?

    login_user(@current_user)
  end
end
