FactoryGirl.define do
  factory :action_image_attachment do
    file File.open(Rails.root.join("test/files/sample.jpg"))
    action
  end
end
