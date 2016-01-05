class Media
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  IMAGE = 1
  VIDEO = 2
  AUDIO = 3
  field :type, type: Integer

  mount_uploader :media, MediaUploader

  validates :type, presence: true
  validates :type, inclusion: {in: [IMAGE, VIDEO, AUDIO]}

  validates :media, presence: true

  def self.count_of(type)
    Media.where(type: type).count
  end
end