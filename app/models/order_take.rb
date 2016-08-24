class OrderTake < ApplicationRecord
  belongs_to :take_along_something
  belongs_to :user
end
