class ActionImageAttachment < ApplicationRecord
  belongs_to :action
  mount_uploader :file, ActionImageUploader
end
