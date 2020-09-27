FactoryBot.define do
  factory :sender do
    sequence(:name) { |n| "sender#{n}" }
    phone {"13800112234"}
    address {"asdfsafasdf234234"}
    longitude {110}
    latitude  {75}
    place {"sender place"}
  end
end
