ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
require 'minitest/hooks/test'

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include Minitest::Hooks

  def before_setup
    ActionImageUploader.any_instance.stubs(:move_to_cache).returns(false)
    ActionImageUploader.any_instance.stubs(:move_to_store).returns(false)

    ActionVideoUploader.any_instance.stubs(:move_to_cache).returns(false)
    ActionVideoUploader.any_instance.stubs(:move_to_store).returns(false)

    DatabaseCleaner.start
  end

  def after_teardown
    DatabaseCleaner.clean
  end

  def after_all
    FileUtils.rm_rf("#{Rails.root}/tmp/uploads")
  end
end

=begin
Dir[Rails.root.join("app/uploaders/*.rb")].each { |f| require f }
CarrierWave::Uploader::Base.descendants.each do |klass|
  next if klass.anonymous?
  klass.class_eval do 
    def cache!(file)
    end

    def store!
    end
  end
end
=end
