FactoryGirl.define do
  factory :action do

    title       "example title"
    place       "example place"
    longitude    32.5
    latitude     62.8
    user

    factory :activity, class: Action do
      category :activity
      start_at { Time.current     }
      end_at   { 10.hour.from_now }

      factory :activity_with_images do
        transient do
          images_count 1
        end

        after(:create) do |activity, evaluator|
          create_list(:action_image_attachment, evaluator.images_count, action: activity)
        end
      end
    end

    factory :living, class: Action do
      category :living

      factory :living_with_videos do
        transient do
          videos_count 1
        end

        after(:create) do |living, evaluator|
          create_list(:action_video_attachment, evaluator.videos_count, action: living)
        end
      end
    end

    factory :take_along_something, class: Action do
      category :take_along_something

      start_at { Time.current     }
      end_at   { 10.hour.from_now }

      sender
      receiver

      factory :take_along_something_with_images do
        transient do
          images_count 1
        end

        after(:create) do |take_along_something, evaluator|
          create_list(:action_image_attachment, evaluator.images_count, action: take_along_something)
        end
      end
    end
  end  
end
