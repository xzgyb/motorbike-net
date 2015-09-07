class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :topic

  field :text, type: String

  validates :text, presence: true

end
