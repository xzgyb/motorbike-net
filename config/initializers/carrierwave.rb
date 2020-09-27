class NullStorage
  attr_reader :uploader

  def initialize(uploader)
    @uploader = uploader
  end

  def identifier
    uploader.filename
  end

  def store!(_file)
    true
  end

  def cache!(*args)
  end

  def retrieve!(_identifier)
    return NullFile.new
  end

  class NullFile
    def delete
    end

    def path
      '/public/uploads/sample.jpg'
    end
  end
end

CarrierWave.configure do |config|
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.asset_host = "http://115.29.110.82"
  
  if Rails.env.test?
    config.storage NullStorage
    config.enable_processing = false
  end
end
