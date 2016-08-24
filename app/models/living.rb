class Living < ApplicationRecord
  include Actionable 

  belongs_to :user

  has_one :event, as: :actionable, dependent: :destroy
  has_one :action, as: :actionable, dependent: :destroy

  has_many :videos, class_name: 'VideoAttachment', dependent: :destroy
  has_many :images, as: :imageable, class_name: 'ImageAttachment', dependent: :destroy

  accepts_nested_attributes_for :videos, :images, allow_destroy: true

  validates :title, 
            :place, 
            :longitude, 
            :latitude, 
            presence: true
end
