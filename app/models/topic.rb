class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_many :posts, dependent: :delete

  field :subject, type: String
  field :text, type: String
  field :views_count, type: Integer, default: 1

  validates :subject, presence: true 
  validates :text, presence: true 

  scope :recent_topics, -> { order_by(:updated_at => :desc) }

  def self.last_post(topic)
    find(topic.id).posts.last
  end
end
