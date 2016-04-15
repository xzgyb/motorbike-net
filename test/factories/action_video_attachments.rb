FactoryGirl.define do
  factory :action_video_attachment do
    file File.open(Rails.root.join("test/files/sample.mp4"))
  end
end
