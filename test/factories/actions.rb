FactoryGirl.define do
  factory :action do

    title       "example title"
    place       "example place"
    coordinates [32.5, 62.8]

    factory :activity, class: Action do
      type     :activity
      start_at { Time.current     }
      end_at   { 10.hour.from_now }

      factory :activity_with_images do
        transient do
          images_count 1
        end

        after(:build) do |activity, evaluator|
          build_list(:action_image_attachment, evaluator.images_count, action: activity)
        end
      end
    end

    factory :living, class: Action do
      type :living

      factory :living_with_videos do
        transient do
          videos_count 1
        end

        after(:build) do |living, evaluator|
          build_list(:action_video_attachment, evaluator.videos_count, action: living)
        end
      end
    end

    factory :take_along_something, class: Action do
      type :take_along_something

      start_at { Time.current     }
      end_at   { 10.hour.from_now }

      factory :take_along_something_with_images do
        transient do
          images_count 1
        end

        after(:build) do |take_along_something, evaluator|
          build_list(:action_image_attachment, evaluator.images_count, action: take_along_something)
        end
      end
    end
  end  
end
