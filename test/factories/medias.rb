FactoryGirl.define do
  factory :media do
    type 1
    media File.open(Rails.root.join("test/files/sample.jpg"))
    user
  end
end
