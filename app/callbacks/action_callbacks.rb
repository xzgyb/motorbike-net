class ActionCallbacks

  class << self
    def after_create(actionable_object)
      user   = actionable_object.user

      action = user.actions.new(longitude:  actionable_object.longitude,
                                latitude:   actionable_object.latitude,
                                actionable: actionable_object,
                                action_type: :sponsor)

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
        actionable_object.saved_change_to_longitude? ||
            actionable_object.saved_change_to_latitude?
      end
  end
end
