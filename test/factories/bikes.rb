FactoryBot.define do
  factory :bike do
    sequence(:name) { |n| "bike#{n}" }
    sequence(:module_id) { |n| "module#{n}" }
    longitude { 33.5 }
    latitude  { 44.5 }
    diag_info { {"hh": "gg", "yy": "kk"} }

    after(:create) do |bike|
      create_list(:location, 5, bike: bike)
    end
  end
end
