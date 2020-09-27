FactoryBot.define do
  factory :app_version do
    app  { File.open(Rails.root.join("test/files/hello.app")) }
    version { "1.0" }
    changelog { "* hello\n* gyb" }
  end
end
