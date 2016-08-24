class ImageAttachment < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  mount_uploader :file, ActionImageUploader
end
