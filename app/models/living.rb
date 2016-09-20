class Living < ApplicationRecord
  include GlobalID::Identification
  include ActionableScopes
  include ActionableCallbacks

  belongs_to :user

  has_one :event, as: :actionable, dependent: :destroy
  has_one :action, as: :actionable, dependent: :destroy

  has_many :videos, class_name: 'VideoAttachment', dependent: :delete_all
  has_many :images, as: :imageable, class_name: 'ImageAttachment', dependent: :delete_all
  has_many :likes, dependent: :delete_all
  has_many :comments, dependent: :delete_all

  accepts_nested_attributes_for :videos, :images, allow_destroy: true

  validates :title, 
            :place, 
            :longitude, 
            :latitude, 
            presence: true
end
