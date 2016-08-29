class ActionCallbacks

  class << self
    def after_create(actionable_object)
      user   = actionable_object.user

      if actionable_object.is_a? Living
        action = user.actions.new(longitude:  actionable_object.longitude,
                                  latitude:   actionable_object.latitude,
                                  actionable: actionable_object)
      else
        action = user.actions.new(longitude:  actionable_object.longitude,
                                  latitude:   actionable_object.latitude,
                                  actionable: actionable_object,
                                  action_type: :sponsor)
      end

      action.save!
    end

    def after_update(actionable_object)
      return unless actionable_object.action

      if need_update_action?(actionable_object)
        actionable_object.action.update!(longitude: actionable_object.longitude,
                                         latitude: actionable_object.latitude)
      end
    end
    
    private
      def need_update_action?(actionable_object)
        actionable_object.changes.include?("longitude") || 
          actionable_object.changes.include?("latitude") 
      end
  end
end
