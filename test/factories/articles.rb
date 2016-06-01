FactoryGirl.define do
  factory :article do
    sequence(:title)   { |n| "title#{n}" }
    body "<img src='http://localhost/1.jpg'/><p>sdfsd</p>"
  end
end
