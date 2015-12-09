class TravelPlan
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :content, type: String, default: ""
  field :start_off_time, type: DateTime
  field :passing_locations, type: Array, default: []
  field :destination_location, type: Array, default: []
  field :status, type: Integer, default: 0
end