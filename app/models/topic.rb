class Topic < ApplicationRecord 
  belongs_to :user
  has_many :posts, dependent: :delete

  validates :subject, presence: true 
  validates :text, presence: true 

  scope :recent_topics, -> { order(updated_at: :desc) }

  def self.last_post(topic)
    find(topic.id).posts.last
  end
end
