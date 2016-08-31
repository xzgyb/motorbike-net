class TakeAlongSomething < ApplicationRecord
  include GlobalID::Identification
  include ActionableScopes
  include ActionableCallbacks

  belongs_to :user

  has_one :sender, dependent: :delete
  has_one :receiver, dependent: :delete
  
  has_one :event, as: :actionable, dependent: :destroy
  has_one :action, as: :actionable, dependent: :destroy

  has_one :order_take, dependent: :destroy
  has_one :order_taker, through: :order_take, source: :user

  has_many :images, as: :imageable, class_name: 'ImageAttachment', dependent: :delete_all

  validates :title, 
            :place, 
            :longitude, 
            :latitude, 
            :start_at, 
            :end_at, 
            presence: true

  accepts_nested_attributes_for :order_take, :images, :sender, :receiver, allow_destroy: true
end
