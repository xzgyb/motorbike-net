class ActionsPushJob < ActiveJob::Base
  include ActionsHelper

  queue_as :default

  def perform(user, longitude, latitude)
    actions = Action.nearby_actions(user, 
                                    :all,
                                    [longitude, latitude])
 
    ActionCable.server.broadcast("actions:#{user.id}", 
                                actions: actions_data(actions, ACTION_ADD))
  end
end
