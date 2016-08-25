class ActionPushCallbacks

  class << self
    def after_create(actionable_object)
      perform_job(actionable_object, ActionPushJob::ACTION_ADD)
    end

    def after_update(actionable_object)
      perform_job(actionable_object, ActionPushJob::ACTION_UPDATE)
    end

    def after_destroy(actionable_object)
      perform_job(actionable_object, ActionPushJob::ACTION_DELETE)
    end

    private
      def perform_job(actionable_object, action_type)
        user = actionable_object.user

        ActionPushJob.perform_later(user, 
                                    actionable_object, 
                                    action_type)

      end 
  end

end
