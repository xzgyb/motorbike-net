require 'test_helper'

class UsersApiTest < ActiveSupport::TestCase
  def setup
    @gyb = create(:user, name: 'gyb')
    @current_user = @gyb

    login_user(@gyb)

    @john  = create(:user, name: 'john')
    @joyce = create(:user, name: 'joyce')
    @peter = create(:user, name: 'peter')
    @mike  = create(:user, name: 'mike')
    @amy   = create(:user, name: 'amy')
  end

  test "GET /api/v1/users/query query the empty user name, and returns a full users list which orderd by name"  do
    get '/api/v1/users/query', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "users"
    assert_includes result, "paginate_meta"

    assert_includes result['users'][0], 'id'
    assert_includes result['users'][0], 'name'

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end

    assert_equal 6, result["users"].count

    result_ids = result["users"].map { |elem| elem["id"] }
    expect_ids = [@amy, @gyb, @john, @joyce, @mike, @peter].map { |e| e.id.to_s }

    assert_equal expect_ids, result_ids
  end

  test "GET /api/v1/users/query query the prefix user name, and returns a users list which contain the prefix user name and orderd by name"  do
    get "/api/v1/users/query/jo", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 2, result["users"].count

    result_ids = result["users"].map { |elem| elem["id"] }
    expect_ids = [@john, @joyce].map { |e| e.id.to_s }

    assert_equal expect_ids, result_ids

    get "/api/v1/users/query/gyb", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 1, result["users"].count
    assert_equal @gyb.id.to_s, result["users"][0]["id"]
  end

  test "GET /api/v1/users/:id returns the specified user info" do
    get "/api/v1/users/#{@john.id}", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "user"

    %w[id name email].each do |field|
      assert_includes result["user"], field
    end

  end
end
