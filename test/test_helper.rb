ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/hooks/test'

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  include Rack::Test::Methods  
  include FactoryBot::Syntax::Methods
  include Minitest::Hooks

  def app; Rails.application; end

  def before_setup
    super

    ActionImageUploader.any_instance.stubs(:move_to_cache).returns(false)
    ActionImageUploader.any_instance.stubs(:move_to_store).returns(false)

    ActionVideoUploader.any_instance.stubs(:move_to_cache).returns(false)
    ActionVideoUploader.any_instance.stubs(:move_to_store).returns(false)

    DatabaseCleaner.start

  end

  def after_teardown
    super
    DatabaseCleaner.clean
  end

  def after_all
    FileUtils.rm_rf("#{Rails.root}/tmp/uploads")
  end

  def login_user(user)
    application = create(:application, owner: user)
    @token = create(:access_token,
                    application: application, 
                    resource_owner_id: user.id)
  end

  def token
    @token ||= login_user(create(:user))
    @token.token
  end

  def create_friendship(user1, user2)
    user1.be_friends_with(user2)
    user2.be_friends_with(user1)
  end

  def new_image_attachment
    Rack::Test::UploadedFile.new(Rails.root.join("test/files/sample.jpg"),
                                                 "image/jpeg")
  end

  def new_video_attachment
    Rack::Test::UploadedFile.new(Rails.root.join("test/files/sample.mp4"),
                                                 "video/mp4")
  end
end

require 'mocha/minitest'