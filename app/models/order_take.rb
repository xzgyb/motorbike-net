class OrderTake < ApplicationRecord
  belongs_to :take_along_something
  belongs_to :user
  has_one :message, as: :message_object, dependent: :destroy

  after_create do |order_take|
    participator         = order_take.user
    take_along_something = order_take.take_along_something

    action = participator.actions.new(longitude: take_along_something.longitude,
                                      latitude:  take_along_something.latitude,
                                      actionable: take_along_something,
                                      action_type: :participant)
    action.save! 
  end

  after_destroy do |order_take|
    participator         = order_take.user
    take_along_something = order_take.take_along_something

    action = participator.actions.participant.where(
      actionable: take_along_something).first

    action.destroy! if action
  end

  after_create do |order_take|
    take_along_something  = order_take.take_along_something
    sponsor               = take_along_something.user

    sponsor.messages.create!(message_object: order_take)
  end

end
