FactoryGirl.define do
  factory :travel_plan do

    content               "hello, travel"
    dest_loc_longitude    32.5
    dest_loc_latitude     62.8
    user

    factory :travel_plan_with_passing_locations do
      transient do
        passing_locations_count 2
      end

      after(:create) do |travel_plan, evaluator|
        create_list(:passing_location, evaluator.passing_locations_count, travel_plan: travel_plan)
      end
    end
  end  
end
