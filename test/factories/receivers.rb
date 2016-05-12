FactoryGirl.define do
  factory :receiver do
    sequence(:name) { |n| "sender#{n}" }
    phone "13800112234"
    address "asdfsafasdf234234"
  end
end
