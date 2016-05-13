require 'securerandom'

class User
  include Mongoid::Document
  include HasFriends
  include GlobalID::Identification

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  # Indicate that updating user operation whether is from api request.
  attr_accessor :api_request

  ## Custom
  field :name, type: String, default: ""
  field :points, type: Integer, default: 0
  field :admin, type: Boolean, default: false
  field :phone, type: String, default: ""
  field :oauth_login_code, type: String, default: ""
  field :online, type: Boolean, default: false

  field :avatar, type: String
  mount_uploader :avatar, AvatarUploader

  field :longitude, type: Float, default: 0
  field :latitude, type: Float, default: 0
  
  validates :name, presence: true, uniqueness: true
  validates :phone, uniqueness: true, allow_blank: true

  embeds_many :bikes
  accepts_nested_attributes_for :bikes, allow_destroy: true

  has_many :travel_plans, dependent: :delete
  has_many :topics, dependent: :delete
  has_many :posts, dependent: :delete
  has_many :medias, dependent: :delete
  has_many :actions do
    def activities
      where('_enumtype' => 'activity')
    end

    def livings
      where('_enumtype' => 'living')
    end

    def take_along_somethings
      where('_enumtype' => 'take_along_something')
    end
  end


  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  scope :name_ordered, -> { order_by(name: :asc) }
  scope :onlined,      -> { where(online: true) }

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
