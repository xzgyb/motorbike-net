class Participation < ApplicationRecord
  belongs_to :activity
  belongs_to :user
end
