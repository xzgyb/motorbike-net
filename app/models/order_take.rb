class OrderTake < ApplicationRecord
  belongs_to :take_along_something
  belongs_to :user

  after_create do |order_take|
    user                 = order_take.user
    take_along_something = order_take.take_along_something

    action = user.actions.new(longitude: take_along_something.longitude,
                              latitude:  take_along_something.latitude,
                              actionable: take_along_something,
                              action_type: :participant)
    action.save! 
  end

  after_destroy do |order_take|
    user                 = order_take.user
    take_along_something = order_take.take_along_something

    action = user.actions.participant.where(
      longitude:  take_along_something.longitude,
      latitude:   take_along_something.latitude,
      actionable: take_along_something).first

    action.destroy! if action
  end

end
