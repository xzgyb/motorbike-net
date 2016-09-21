require 'api/entities/video_attachment'
require 'api/entities/image_attachment'
require 'api/entities/like'
require 'api/entities/comment'

module Api::Entities
  class Living < Grape::Entity
    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose :id, :user_id, :title, :place, :price, :longitude, :latitude, :distance
    expose :content, if: :export_content

    with_options(format_with: :time) { expose :updated_at }
  
    expose :videos, using: VideoAttachment
    expose :images, using: ImageAttachment

    expose :likes, using: Like do |living, options|
      living.likes.limit(options[:per_like_page] || 20).offset(0).order(:id)
    end

    expose :total_likes_count do |living, _|
      living.likes.count
    end

    expose :comments, using: Comment do |living, options|
      living.comments.limit(options[:per_comment_page] || 20).offset(0).order(:id)
    end

    expose :total_comments_count do |living, _|
      living.comments.count
    end

    root "livings", "living"
  end
end
