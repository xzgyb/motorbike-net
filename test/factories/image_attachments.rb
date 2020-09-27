FactoryBot.define do
  factory :image_attachment do
    file {File.open(Rails.root.join("test/files/sample.jpg"))}
  end
end
