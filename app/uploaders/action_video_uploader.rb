class ActionVideoUploader < ActionUploaderBase
  include CarrierWave::Video::Thumbnailer

  version :thumb do
    process thumbnail: [{format: 'png', quality: 10, size: 120, strip: true, logger: Rails.logger}]
    
    def full_filename(for_file)
      "#{version_name}_#{for_file.chomp(File.extname(for_file))}.png"
    end
  end
end
