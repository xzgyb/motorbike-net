FactoryBot.define do
  factory :access_grant, class: Doorkeeper::AccessGrant do
    sequence(:resource_owner_id) { |n| n }
    application
    redirect_uri     { 'urn:ietf:wg:oauth:2.0:oob' }
    sequence(:token) { |_n| SecureRandom.hex }
  end
end
