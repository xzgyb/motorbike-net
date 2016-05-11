require 'test_helper'

class FriendsApiTest < ActiveSupport::TestCase
  def setup
    @gyb = create(:user, name: 'gyb')
    @current_user = @gyb

    login_user(@gyb)

    @john  = create(:user, name: 'john')
    @peter = create(:user, name: 'peter')
    @mike  = create(:user, name: 'mike')
    @amy   = create(:user, name: 'amy')
  end

  test "GET /api/v1/friends returns current user's friends list which ordered by name"  do

    create_friendship(@gyb, @john)
    create_friendship(@gyb, @peter)
    create_friendship(@gyb, @mike)
    create_friendship(@gyb, @amy)

    get '/api/v1/friends', access_token: token

    assert last_response.ok?
    
    result = JSON.parse(last_response.body)

    assert_includes result, "friends"
    assert_includes result, "paginate_meta"

    assert_includes result['friends'][0], 'id'
    assert_includes result['friends'][0], 'name'

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end

    assert_equal 4, result["friends"].count

    result_ids = result["friends"].map { |elem| elem["id"] }
    expect_ids = [@amy, @john, @mike, @peter].map { |e| e.id.to_s }

    assert_equal expect_ids, result_ids
  end

  test "GET /api/v1/friends/pending returns current user's pending friends list which ordered by name"  do
    @john.be_friends_with(@current_user) 
    @peter.be_friends_with(@current_user)
    @amy.be_friends_with(@current_user)

    get '/api/v1/friends/pending', access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "pending_friends"
    assert_includes result, "paginate_meta"

    assert_includes result['pending_friends'][0], 'id'
    assert_includes result['pending_friends'][0], 'name'

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end

    assert_equal 3, result["pending_friends"].count

    result_ids = result["pending_friends"].map { |elem| elem["id"] }
    expect_ids = [@amy, @john, @peter].map { |e| e.id.to_s }

    assert_equal expect_ids, result_ids

  end

  test 'POST /api/v1/friends add a friend request for current user' do
    post '/api/v1/friends', access_token: token, friend_id: @john.id
    assert last_response.created?
   
    friendship, status = @current_user.be_friends_with(@john)
    assert_nil friendship
    assert_equal Friendship::STATUS_ALREADY_REQUESTED, status
  end

  test 'POST /api/v1/friends/accept accepts a friend request for current user' do
    @john.be_friends_with(@current_user)
    
    post '/api/v1/friends/accept', access_token: token, friend_id: @john.id
    assert last_response.created?

    get '/api/v1/friends', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 1, result["friends"].count
    assert_equal @john.id.to_s, result["friends"][0]['id']

    login_user(@john)

    get '/api/v1/friends', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 1, result["friends"].count
    assert_equal @gyb.id.to_s, result["friends"][0]['id']
  end

  test 'DELETE /api/v1/friends/deny/:friend_id denies a friend request for current user' do
    @john.be_friends_with(@current_user)

    assert_equal 1, @current_user.pending_friends.count

    delete "/api/v1/friends/deny/#{@john.id}", access_token: token
    assert last_response.ok?

    assert_equal 0, @current_user.pending_friends.count
  end

  test 'DELETE /api/v1/friends/:friend_id should delete a friendship between current user and his friend' do
    create_friendship(@current_user, @john)

    delete "/api/v1/friends/#{@john.id}", access_token: token
    assert last_response.ok?

    assert_equal 0, @current_user.friends.count
    assert_equal 0, @john.friends.count
  end
end
