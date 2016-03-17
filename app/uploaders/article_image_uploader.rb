# encoding: utf-8

class ArticleImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  class_attribute :saved_filename
  after :store, :reset_saved_filename!

  storage :file
  move_to_store true

  process resize_to_fit: [650, 650]
  version :thumb do
    process resize_to_fit: [165, 120]
  end

  def filename
    ArticleImageUploader.saved_filename ||= DateTime.now.strftime('%Y%m%d%H%M%S') +
                                            SecureRandom.hex(16) +
                                            File.extname(@filename)
    ArticleImageUploader.saved_filename
  end

  def store_dir
    "uploads/article_images"
  end

  def size_range
    100..(2 * 1024 * 1024)
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private
    def reset_saved_filename!(*args)
      ArticleImageUploader.saved_filename = nil
    end

end
