module Api::Entities
  class TravelPlan < Grape::Entity

    format_with(:time) { |dt| dt ? dt.strftime("%Y-%m-%d %H:%M:%S") : "" }

    expose :_id, as: :id do |instance, options|
      instance._id.to_s
    end
    expose :content
    expose :passing_locations
    expose :destination_location
    expose :status


    root "travel_plans", "travel_plan"

    with_options(format_with: :time) do
      expose :start_off_time
    end
  end
end
