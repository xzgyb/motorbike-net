class Participation < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  has_one :message, as: :message_object, dependent: :destroy

  after_create do |participation|
    participator = participation.user
    activity     = participation.activity

    action = participator.actions.new(longitude: activity.longitude,
                                      latitude:  activity.latitude,
                                      actionable: activity,
                                      action_type: :participant)
    action.save! 
  end

  after_destroy do |participation|
    participator = participation.user
    activity     = participation.activity

    action = participator.actions.participant.where(
      actionable: activity).first

    action.destroy! if action
  end

  after_create do |participation|
    activity  = participation.activity
    sponsor   = activity.user

    sponsor.messages.create!(message_object: participation)
  end
end
