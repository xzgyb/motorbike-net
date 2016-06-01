require 'test_helper'

class ActionTest < ActiveSupport::TestCase

  def setup
    @activity_action = build(:activity_with_images)
    @living_action = build(:living_with_videos)
    @take_along_something_action = build(:take_along_something_with_images)
  end

  test "should be valid with a title, place, start_time, end_time, longitude, latitude and images when type is activity" do
    assert @activity_action.valid? 
  end

  test "title should be present when type is activity" do
    @activity_action.title = ' ' 
    assert_not @activity_action.valid?
  end

  test "place should be present when type is activity" do
    @activity_action.place = ' '
    assert_not @activity_action.valid?    
  end

  test "start_time and end_time should be present when type is activity" do
    @activity_action.start_at = ''
    assert_not @activity_action.valid?

    @activity_action.end_at = ''
    assert_not @activity_action.valid?
  end

  test "longitude, latitude should be present when type is activity" do
    @activity_action.longitude = @activity_action.latitude = '' 
    assert_not @activity_action.valid?
  end

  test "images can be not present when type is activity" do
    @activity_action.images = []
    assert @activity_action.valid?
  end

  test "should be valid with a title, place, longitude, latitude and videos when type is living" do
    assert @living_action.valid?
  end

  test "title should be present when type is living" do
    @living_action.title = ''
    assert_not @living_action.valid?
  end

  test "place should be present when type is living" do
    @living_action.place = ''
    assert_not @living_action.valid?
  end

  test "longitude, latitude should be present when type is living" do
    @living_action.longitude, latitude = []
    assert_not @living_action.valid?
  end

  test "videos can be not present when type is living" do
    @living_action.videos = []
    assert @living_action.valid?
  end


  test "should be valid with a title, place, longitude, latitude and images when type is take_along_something" do
    assert @take_along_something_action.valid?
  end

  test "title should be present when type is take_along_something" do
    @take_along_something_action.title = ''
    assert_not @take_along_something_action.valid?
  end

  test "place should be present when type is take_along_something" do
    @take_along_something_action.place = ''
    assert_not @take_along_something_action.valid?
  end

  test "start_time and end_time should be present when type is take_along_something" do
    @take_along_something_action.start_at = ''
    assert_not @take_along_something_action.valid?

    @take_along_something_action.end_at = ''
    assert_not @take_along_something_action.valid?
  end

  test "longitude, latitude should be present when type is take_along_something" do
    @take_along_something_action.longitude = ''
    @take_along_something_action.latitude  = ''
     
    assert_not @take_along_something_action.valid?
  end

  test "images can be not present when type is take_along_something" do
    @take_along_something_action.images = []
    assert @take_along_something_action.valid?
  end

end
