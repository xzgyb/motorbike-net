class ActionPushJob < ActiveJob::Base
  queue_as :default
 
  # status value for action
  ACTION_ADD    = 0
  ACTION_DELETE = 1
  ACTION_UPDATE = 2

  def perform(user, action, status)
    onlined_users = user.onlined_friends.to_a
    onlined_users << user if user.online?

    data = action_data(action, status)

    onlined_users.each do |user|
      ActionCable.server.broadcast("action:#{user.id}", 
                                   action: data)
    end
  end

  private
    def action_data(action, status)
      {id:        action.id,
       user_id:   action.user_id,
       type:      Action.type_code(action),
       longitude: action.longitude.to_s,
       latitude:  action.latitude.to_s,
       status:    status}
    end
end
