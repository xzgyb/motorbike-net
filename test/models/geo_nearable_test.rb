require 'test_helper'

class GeoNearableTest < ActiveSupport::TestCase
  test 'nearby should work' do
    create_list(:activity_with_images, 10)
    Action.near([32.53, 62.7], max_distance: 100)
  end
end
