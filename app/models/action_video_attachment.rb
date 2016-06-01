class ActionVideoAttachment < ApplicationRecord
  belongs_to :action
  mount_uploader :file, ActionVideoUploader
end
