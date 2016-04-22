FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    sequence(:name) { |n| "name#{n}" }
    redirect_uri 'http://foobar.com'
    association :owner, factory: :user
  end
end
