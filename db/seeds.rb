# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin_user = User.create!(
  name:                  ENV['ADMIN_USER_NAME'],
  password:              ENV['ADMIN_USER_PASSWORD'],
  password_confirmation: ENV['ADMIN_USER_PASSWORD'],
  email:                 ENV['ADMIN_USER_EMAIL'],
  admin:                 true);

Doorkeeper::Application.create!(name:         ENV['OAUTH_APPLICATION_NAME'],
                                uid:          ENV['OAUTH_APPLICATION_UID'],
                                secret:       ENV['OAUTH_APPLICATION_SECRET'],
                                redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
                                owner:        admin_user)


