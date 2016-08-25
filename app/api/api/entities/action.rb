require 'api/entities/image_attachment'
require 'api/entities/video_attachment'

module Api::Entities
  class Action < Grape::Entity
    HAS_IMAGES_IF_LAMBDA = lambda { |obj, _| has_images?(obj) }
    HAS_VIDEOS_IF_LAMBDA = lambda { |obj, _| has_videos?(obj) }

    format_with(:time) { |dt| dt.strftime("%Y-%m-%d %H:%M:%S") }

    expose :id, :user_id

    expose(:type) { |instance, _| 
      ::Action.type_code(instance.actionable)
    }

    expose(:title) { |instance, _| instance.actionable.title }
    expose(:place) { |instance, _| instance.actionable.place }
    expose(:price) { |instance, _| instance.actionable.price }

    expose :longitude, :latitude
    expose(:content, if: :export_content) { |instance, _| 
      instance.actionable.content 
    }

    expose(:updated_at)  { |instance, _| 
      instance.actionable.updated_at.strftime("%Y-%m-%d %H:%M:%S")
    }

    expose(:start_at, if: HAS_IMAGES_IF_LAMBDA) { |instance, _|
      instance.actionable.start_at.strftime("%Y-%m-%d %H:%M:%S")
    } 

    expose(:end_at, if: HAS_IMAGES_IF_LAMBDA) { |instance, _|
      instance.actionable.end_at.strftime("%Y-%m-%d %H:%M:%S")
    } 

    expose(:images, 
           using: ImageAttachment, 
           if: HAS_IMAGES_IF_LAMBDA) { |instance, _|
      instance.actionable.images
    } 
           
    expose(:videos,
           using: VideoAttachment,
           if: HAS_VIDEOS_IF_LAMBDA) { |instance, _|
      instance.actionable.videos
    } 

    private
      def has_images?(obj)
        obj.actionable.is_a?(Activity) or obj.actionable.is_a?(TakeAlongSomething)
      end

      def has_videos?(obj)
        obj.actionable.is_a?(Living)
      end

    root "actions", "action"
  end
end
