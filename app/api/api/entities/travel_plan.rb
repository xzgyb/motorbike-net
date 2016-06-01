require 'api/entities/passing_location'

module Api::Entities
  class TravelPlan < Grape::Entity

    format_with(:time) { |dt| dt ? dt.strftime("%Y-%m-%d %H:%M:%S") : "" }

    expose :id, :content, :dest_loc_longitude, :dest_loc_latitude, :status
    expose :passing_locations, using: PassingLocation

    root "travel_plans", "travel_plan"

    with_options(format_with: :time) do
      expose :start_off_time
    end
  end
end
