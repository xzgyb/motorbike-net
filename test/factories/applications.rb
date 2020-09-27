FactoryBot.define do
  factory :application, class: Doorkeeper::Application do
    sequence(:name) { |n| "name#{n}" }
    redirect_uri  { 'http://foobar.com' }
  end
end
