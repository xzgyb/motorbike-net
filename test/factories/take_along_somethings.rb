FactoryBot.define do
  factory :take_along_something do

    title       {"example title"}
    place       {"example place"}
    longitude    {32.5}
    latitude     {62.8}
    user

    start_at { Time.current     }
    end_at   { 10.hour.from_now }
    sender
    receiver

    factory :take_along_something_with_images do
      transient do
        images_count {1}
      end

      after(:create) do |take_along_something, evaluator|
        create_list(:image_attachment, evaluator.images_count, imageable: take_along_something)
      end
    end

  end  
end
