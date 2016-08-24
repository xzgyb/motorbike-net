class Action < ApplicationRecord
  include Actionable

  belongs_to :user
  belongs_to :actionable, polymorphic: true
end
