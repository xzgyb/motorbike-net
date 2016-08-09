FactoryGirl.define do
  factory :event do

    title       "example title"
    content     "hello content"
    place       "example place"
    longitude    32.5
    latitude     62.8
    start_at     { Time.current }
    end_at       { 10.hour.from_now }
    event_type   :event
    user
  end  
end
