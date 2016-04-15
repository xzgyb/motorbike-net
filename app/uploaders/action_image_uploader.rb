class ActionImageUploader < ActionUploaderBase
  include CarrierWave::MiniMagick

  process resize_to_fit: [650, 650]
  version :thumb do
    process resize_to_fit: [120, 90]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
