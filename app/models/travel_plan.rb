class TravelPlan < ApplicationRecord 
  belongs_to :user
  has_many :passing_locations
  accepts_nested_attributes_for :passing_locations, allow_destroy: true
end
