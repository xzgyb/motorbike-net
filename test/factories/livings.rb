FactoryBot.define do
  factory :living do

    title       { "example title" }
    place       { "example place" }
    longitude   { 32.5 }
    latitude    { 62.8 }
    user

    factory :living_with_videos_images do
      transient do
        videos_count { 1 }
        images_count { 1 }
      end

      after(:create) do |living, evaluator|
        create_list(:video_attachment, evaluator.videos_count, living: living)
        create_list(:image_attachment, evaluator.images_count, imageable: living)
      end
    end

  end  
end
