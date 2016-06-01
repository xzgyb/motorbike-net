require 'test_helper'

class ArticlesApiTest < ActiveSupport::TestCase
  def setup
    create_list(:article, 3, published: true)
  end

  test "GET /api/v1/articles should returns a articles list" do
    get "/api/v1/articles"
    assert last_response.ok?

    result = JSON.parse(last_response.body)
    assert_includes result, "articles"

    assert_equal Article.count, result["articles"].count
    %w[id title title_image_url].each do |field|
      assert_includes result["articles"][0], field
    end
  end

  test "GET /api/v1/articles/:id should returns a articles list" do
    get "/api/v1/articles/#{Article.first.id}"
    assert last_response.ok?

    result = JSON.parse(last_response.body)
    assert_includes result, "article"

    %w[id title title_image_url body].each do |field|
      assert_includes result["article"], field
    end
  end
end
