class NearbyActionsPushJob < ActiveJob::Base
  include ActionsHelper

  queue_as :default

  def perform(user, longitude, latitude)
    max_instance = user.max_distance || 5

    actions = Action.nearby_actions(user, 
                                    :all,
                                    [longitude, latitude],
                                    max_distance: max_distance)

    ActionCable.server.broadcast("nearby_actions:#{user.id}",
                                actions: actions_data(actions, ACTION_ADD))
  end
end
