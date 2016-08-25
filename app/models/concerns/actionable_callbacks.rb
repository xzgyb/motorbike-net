module ActionableCallbacks
  extend ActiveSupport::Concern

  included do
    after_create EventCallbacks, ActionCallbacks, ActionPushCallbacks
    after_update ActionCallbacks, ActionPushCallbacks
    after_destroy ActionPushCallbacks
  end
end
