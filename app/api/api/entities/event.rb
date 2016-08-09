module Api::Entities
  class Event < Grape::Entity
    expose :id

    expose :title do |event, _| 
      event.event? ? event.title : event.action.title
    end

    expose :content do |event, _| 
      event.event? ? event.content : event.action.content 
    end

    expose :longitude do |event, _| 
      event.event? ? event.longitude : event.action.longitude 
    end

    expose :latitude do |event, _| 
      event.event? ? event.latitude : event.action.latitude 
    end

    expose :place do |event, _| 
      event.event? ? event.place : event.action.place
    end 

    expose :image_url do |event, _|
      if event.activity? || event.take_along_something?
        event.action.images.empty? ? ""
                                   : event.action.images.first.file.url(:thumb)

      elsif event.living?
        event.action.videos.empty? ? ""
                                   : event.action.videos.first.file.url(:thumb)
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
