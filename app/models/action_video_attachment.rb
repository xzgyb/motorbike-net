class ActionVideoAttachment
  include Mongoid::Document
  belongs_to :action

  field :file, type: String

  mount_uploader :file, ActionVideoUploader
end
