FactoryBot.define do
  factory :activity do

    title       { "example title" }
    place       { "example place" }
    longitude   { 32.5 }
    latitude    { 62.8 }
    user

    start_at { Time.current     }
    end_at   { 10.hour.from_now }

    factory :activity_with_images do
      transient do
        images_count { 1 }
      end

      after(:create) do |activity, evaluator|
        create_list(:image_attachment, evaluator.images_count, imageable: activity)
      end
    end

  end  
end
