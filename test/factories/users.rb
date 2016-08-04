FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "email#{n}@hello.com" }
    password 'password'
    password_confirmation 'password'
    phone            { |n| "138#{n}".ljust(11, '0') }

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
