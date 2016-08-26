class Participation < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  after_create do |participation|
    user     = participation.user
    activity = participation.activity

    action = user.actions.new(longitude: activity.longitude,
                              latitude:  activity.latitude,
                              actionable: activity,
                              action_type: :participant)
    action.save! 
  end

  after_destroy do |participation|
    user     = participation.user
    activity = participation.activity

    action = user.actions.participant.where(
      longitude:  activity.longitude,
      latitude:   activity.latitude,
      actionable: activity).first

    action.destroy! if action
  end
end
