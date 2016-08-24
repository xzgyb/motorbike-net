module Api::Entities
  class Event < Grape::Entity
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

    expose :image_url do |event, _|
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
    
    expose :start_at
    expose :end_at

    expose(:type) { |instance, _| ::Event.event_types[instance.event_type] }

    root "events", "event"
  end
end
