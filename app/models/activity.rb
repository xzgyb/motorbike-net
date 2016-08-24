class Activity < ApplicationRecord
  include Actionable 

  belongs_to :user

  has_many :images, as: :imageable, class_name: 'ImageAttachment', dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :participators, through: :participations, source: :user

  has_one :event, as: :actionable, dependent: :destroy
  has_one :action, as: :actionable, dependent: :destroy

  validates :title, 
            :place, 
            :longitude, 
            :latitude, 
            :start_at, 
            :end_at, 
            presence: true

  accepts_nested_attributes_for :images, :participations, allow_destroy: true
end
