require 'securerandom'

class User < ApplicationRecord 
  include HasFriends
  include GlobalID::Identification

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Indicate that updating user operation whether is from api request.
  attr_accessor :api_request

  mount_uploader :avatar, AvatarUploader

  
  validates :name, presence: true, uniqueness: true
  validates :phone, uniqueness: true, allow_blank: true

  has_many :bikes
  accepts_nested_attributes_for :bikes, allow_destroy: true

  has_many :travel_plans, dependent: :delete_all
  has_many :topics, dependent: :delete_all
  has_many :posts, dependent: :delete_all
  has_many :medias, dependent: :delete_all

  has_many :actions
  has_many :activities
  has_many :livings
  has_many :take_along_somethings

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner
  has_many :events

  scope :name_ordered,  -> { order(:name) }
  scope :email_ordered, -> { order(:email) }
  scope :onlined,       -> { where(online: true) }

  before_create do
    self.oauth_login_code = SecureRandom.hex(10)
  end

  def valid_oauth_login_code?(code)
    oauth_login_code && oauth_login_code == code
  end

  def onlined_friends
    self.friends.onlined
  end

  protected
  def email_required?
    api_request ? false : true
  end
end
