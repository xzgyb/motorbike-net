class Article
  include Mongoid::Document

  field :title,             type: String
  field :title_picture_url, type: String, default: ''
  field :body,              type: String
  field :published,         type: Boolean, default: false

  validates :title, presence:true, uniqueness: true
  validates :body, presence:true
end
