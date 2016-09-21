module Api::Entities
  class Event < Grape::Entity
    IS_ACTION_IF_LAMBDA = lambda do |event, _| 
      !event.event?
    end 

    expose :id

    expose :title do |event, _| 
      event.event? ? event.title : event.actionable.title
    end

    expose :content do |event, _| 
      event.event? ? event.content : event.actionable.content 
    end

    expose :longitude do |event, _| 
      event.event? ? event.longitude : event.actionable.longitude 
    end

    expose :latitude do |event, _| 
      event.event? ? event.latitude : event.actionable.latitude 
    end

    expose :place do |event, _| 
      event.event? ? event.place : event.actionable.place
    end 

    expose :price do |event, _| 
      event.event? ? "" : event.actionable.price
    end 

    expose(:image_url) do |event, _|
      if event.activity? || event.take_along_something?
        event.actionable.images.empty? ? ""
                                   : event.actionable.images.first.file.url(:thumb)

      elsif event.living?
        event.actionable.videos.empty? ? ""
                                   : event.actionable.videos.first.file.url(:thumb)
      else
        ""
      end
    end

    expose(:action_id, if: IS_ACTION_IF_LAMBDA) do |event, _|
      event.actionable.id
    end
    
    expose(:start_at) do |event, _|
      if event.start_at.present?
        event.start_at.strftime("%Y-%m-%d %H:%M:%S")
      else
        ""
      end
    end

    expose(:end_at) do |event, _|
      if event.end_at.present?
        event.end_at.strftime("%Y-%m-%d %H:%M:%S")
      else
        ""
      end
    end

    expose(:type) { |instance, _| ::Event.event_types[instance.event_type] }

    root "events", "event"
  end
end
