class FriendLocationPushJob < ActiveJob::Base
  queue_as :default


  def perform(user, longitude, latitude)
    onlined_users = user.onlined_friends.to_a
    onlined_users << user if user.online?

    data = location_data(user, longitude, latitude)

    onlined_users.each do |user|
      ActionCable.server.broadcast("friend_location:#{user.id}", 
                                   friend_location: data)
    end
  end

  private
    def location_data(user, longitude, latitude)
      {user_id: user.id,
       longitude: longitude.to_s,
       latitude: latitude.to_s}
    end
end
