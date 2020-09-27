FactoryBot.define do
  factory :video_attachment do
    file {File.open(Rails.root.join("test/files/sample.mp4"))}
    living
  end
end
