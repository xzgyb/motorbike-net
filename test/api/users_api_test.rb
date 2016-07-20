require 'test_helper'

class UsersApiTest < ActiveSupport::TestCase
  def setup
    @gyb = create(:user, name: 'gyb')
    @current_user = @gyb

    login_user(@gyb)

    @john  = create(:user, name: 'john', phone: '13811234567', email: 'john@example.com')
    @joyce = create(:user, name: 'joyce', phone: '138123566897', email: 'joyce@example.com')
    @peter = create(:user, name: 'peter', phone: '13911548765', email: 'peter@example.com')
    @mike  = create(:user, name: 'mike', phone: '13812357890', email: 'mike@example.com')
    @amy   = create(:user, name: 'amy', phone: '13334561278', email: 'amy@example.com')
  end

  test "GET /api/v1/users/validation_code should work" do
    get '/api/v1/users/validation_code?phone=13811111111&type=1'
    assert last_response.ok?
  end

  test "POST /api/v1/users/register should work twice" do
    get '/api/v1/users/validation_code?phone=13811111111&type=1'
    assert last_response.ok?

    get '/api/v1/users/get_validation_code/13811111111'
    assert last_response.ok?
    
    validation_code = last_response.body.delete('"')
    post '/api/v1/users/register?phone=13811111111&validation_code=' + validation_code
    assert last_response.created?
    
    result = JSON.parse(last_response.body)
    assert_includes result, 'oauth_login_code'
    
    get '/api/v1/users/validation_code?phone=13811111112&type=1'
    assert last_response.ok?

    get '/api/v1/users/get_validation_code/13811111112'
    assert last_response.ok?
    
    validation_code = last_response.body.delete('"')
    post '/api/v1/users/register?phone=13811111112&validation_code=' + validation_code
    assert last_response.created?
    
    result = JSON.parse(last_response.body)
  end

  test "POST /api/v1/users/login should work" do
    get "/api/v1/users/validation_code?phone=#{@john.phone}&type=2"
    assert last_response.ok?

    get "/api/v1/users/get_validation_code/#{@john.phone}"
    assert last_response.ok?

    validation_code = last_response.body.delete('"')
    post "/api/v1/users/login?phone=#{@john.phone}&validation_code=" + validation_code
    assert last_response.created?

    result = JSON.parse(last_response.body)
    assert_includes result, 'oauth_login_code'
  end

  test "PUT /api/v1/users/reset should work" do
    old_encrypted_password = @john.encrypted_password

    get "/api/v1/users/validation_code?phone=#{@john.phone}&type=3"
    assert last_response.ok?

    get "/api/v1/users/get_validation_code/#{@john.phone}"
    assert last_response.ok?

    validation_code = last_response.body.delete('"')
    put "/api/v1/users/reset?phone=#{@john.phone}&validation_code=" + 
      validation_code + "&password=12345678&password_confirmation=12345678"

    assert last_response.ok?
    assert_not_equal old_encrypted_password, @john.reload.encrypted_password
  end

  test "PUT /api/v1/users/update should work" do
    old_encrypted_password = @current_user.encrypted_password
    old_name               = @current_user.name

    put "/api/v1/users/update?name=hello&password=12345678&password_confirmation=12345678", access_token: token

    assert last_response.ok?
    @current_user.reload

    assert_not_equal old_name, @current_user.name
    assert_not_equal old_encrypted_password, @current_user.encrypted_password
  end

  test "Update the user's avatar image only should work" do
    file = Rack::Test::UploadedFile.new(Rails.root.join("test/files/sample.jpg"),
                                        "image/jpg")

    
    put "/api/v1/users/update",
        access_token: token,
        avatar: file

    assert last_response.ok?

    @current_user.reload
    assert @current_user.avatar.url
  end

  test "GET /api/v1/users/query query the empty user name, and returns a full users list which orderd by name"  do
    get '/api/v1/users/query', access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "users"
    assert_includes result, "paginate_meta"

    assert_includes result['users'][0], 'id'
    assert_includes result['users'][0], 'name'
    assert_includes result['users'][0], 'avatar_url'

    %w[current_page next_page prev_page total_pages total_count].each do |field|
      assert_includes result["paginate_meta"], field
    end

    assert_equal 6, result["users"].count

    result_ids = result["users"].map { |elem| elem["id"] }
    expect_ids = [@amy, @gyb, @john, @joyce, @mike, @peter].map { |e| e.id }

    assert_equal expect_ids, result_ids
  end

  test "GET /api/v1/users/query query the prefix user name, and returns a users list which contain the prefix user name and orderd by name"  do
    get "/api/v1/users/query/jo", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 2, result["users"].count

    result_ids = result["users"].map { |elem| elem["id"] }
    expect_ids = [@john, @joyce].map { |e| e.id }

    assert_equal expect_ids, result_ids

    get "/api/v1/users/query/gyb", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 1, result["users"].count
    assert_equal @gyb.id, result["users"][0]["id"]
  end

  test "GET /api/v1/users/query query the prefix phone and returns a users list whose phone contain the prefix phone and orderd by name"  do
    get "/api/v1/users/query/#{@john.phone}", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 1, result["users"].count
    assert_equal @john.id, result["users"][0]["id"]

    get "/api/v1/users/query/1381", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_equal 3, result["users"].count

    result_ids = result["users"].map { |elem| elem["id"] }
    expect_ids = [@john, @joyce, @mike].map { |e| e.id }

    assert_equal expect_ids, result_ids

  end

  test "GET /api/v1/users/:id returns the specified user info" do
    get "/api/v1/users/#{@john.id}", access_token: token
    assert last_response.ok?

    result = JSON.parse(last_response.body)

    assert_includes result, "user"

    %w[id name email title level travel_mileage avatar_url].each do |field|
      assert_includes result["user"], field
    end
  end

  test "GET /api/v1/users/info returns the current user info" do
    get "/api/v1/users/info", access_token: token

    assert last_response.ok?

    result = JSON.parse(last_response.body)
    assert_includes result, "user"

    %w[id name email title level travel_mileage avatar_url].each do |field|
      assert_includes result["user"], field
    end
  end
end
