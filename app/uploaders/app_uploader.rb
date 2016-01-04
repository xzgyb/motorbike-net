# encoding: utf-8

class AppUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end
end
