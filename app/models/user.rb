class User
  include Mongoid::Document
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
  field :module_id, type: String, default: ""
  field :points, type: Integer, default: 0
  field :admin, type: Boolean, default: false
  field :phone, type: String, default: ""
  field :oauth_login_code, type: String, default: ""
  
  validates :name, presence: true, uniqueness: true
  validates :module_id, uniqueness: true
  
  embeds_one :bike, autobuild: true
  has_many :topics, dependent: :delete
  has_many :posts, dependent: :delete
  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  def valid_oauth_login_code?(code)
    oauth_login_code && oauth_login_code == code
  end

  protected
  def email_required?
    api_request ? false : true
  end
end
