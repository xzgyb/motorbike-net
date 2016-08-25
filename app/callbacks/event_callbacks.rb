# Create event after create activity, take along something, living.
class EventCallbacks
  class << self
    def after_create(actionable_object)
      user = actionable_object.user 

      if actionable_object.is_a?(Living)
        event = user.events.new(event_type: event_type(actionable_object),
                                actionable: actionable_object)
      else
        event = user.events.new(event_type: event_type(actionable_object),
                                start_at:   actionable_object.start_at,
                                end_at:     actionable_object.end_at,
                                actionable: actionable_object)
      end

      event.save!
    end

    private
      def event_type(actionable_object)
        case actionable_object
        when Activity then :activity 
        when Living then :living
        when TakeAlongSomething then :take_along_something
        end
      end
  end
end
