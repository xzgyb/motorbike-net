class Article

  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,             type: String
  field :title_image_url,   type: String
  field :body,              type: String
  field :published,         type: Boolean, default: false

  validates :title, presence:true, uniqueness: true
  validates :body, presence:true
  validate :has_image

  before_save :save_title_image_url

  scope :latest, -> { order_by(:updated_at => :desc) }
  scope :published, -> { where(published: true) }

  def has_image
    if body.present?
      doc = Nokogiri::HTML(body)
      img = doc.css("img").first
      errors.add(:body, :has_image) if img.nil?
    end
  end

  def save_title_image_url
    doc = Nokogiri::HTML(body)
    img = doc.css("img").first
    url = img['src']

    self.title_image_url = File.join(File.dirname(url),
                                     "thumb_" + File.basename(url))
  end

end
