class Event < ApplicationRecord
  enum event_type: [:activity, :living, :take_along_something, :event]

  belongs_to :user
  belongs_to :actionable, polymorphic: true

  scope :latest, -> { order(updated_at: :desc) }
end
