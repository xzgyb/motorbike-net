FactoryGirl.define do
  factory :bike do
    sequence(:name) { |n| "bike#{n}" }
    sequence(:module_id) { |n| "module#{n}" }
    longitude 33.5
    latitude  44.5

    after(:create) do |bike|
      create_list(:location, 5, bike: bike)
    end
  end
end
