module ActionsHelper
  
  # status value for action
  ACTION_ADD    = 0
  ACTION_DELETE = 1
  ACTION_UPDATE = 2

  def actions_data(actions, status)
    actions.inject([]) do |result, action|
      result << action_data(action, status) 
    end 
  end

  def action_data(action, status)
    {id:        action.id, 
     user_id:   action.user_id,
     type:      action.type,
     longitude: action.longitude,
     latitude:  action.latitude,
     status:    status}
  end
end
