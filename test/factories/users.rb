FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "email#{n}@hello.com" }
    password 'password'
    password_confirmation 'password'
    phone            { "138" + (1..8).to_a.shuffle.join }

    factory :user_with_bikes do
      transient do
        bikes_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:bike, evaluator.bikes_count, user: user)
      end
    end
  end
end
