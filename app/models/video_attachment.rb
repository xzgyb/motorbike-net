class VideoAttachment < ApplicationRecord
  belongs_to :living
  mount_uploader :file, ActionVideoUploader
end
