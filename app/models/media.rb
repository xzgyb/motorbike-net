class Media < ApplicationRecord 
  self.inheritance_column = :_type 

  belongs_to :user

  IMAGE = 1
  VIDEO = 2
  AUDIO = 3

  mount_uploader :media, MediaUploader

  validates :type, presence: true
  validates :type, inclusion: {in: [IMAGE, VIDEO, AUDIO]}
  validates :media, presence: true

  scope :of_type, -> (type) { where(type: type) }
end
