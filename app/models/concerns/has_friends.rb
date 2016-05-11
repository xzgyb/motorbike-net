module HasFriends
  extend ActiveSupport::Concern

  included do
    include Mongoid::Attributes::Dynamic

    has_many :friendships
    after_destroy :destroy_all_friendships
  end

  def be_friends_with(friend)
    # no user object
    return nil, Friendship::STATUS_FRIEND_IS_REQUIRED unless friend

    # should not create friendship if user is trying to add himself
    return nil, Friendship::STATUS_IS_YOU if is?(friend)

    # should not create friendship if users are already friends
    return nil, Friendship::STATUS_ALREADY_FRIENDS if friends?(friend)

    # retrieve the friendship request
    friendship = self.friendship_for(friend)

    # let's check if user has already a friendship request or have removed
    request = friend.friendship_for(self)

    # friendship has already been requested
    return nil, Friendship::STATUS_ALREADY_REQUESTED if friendship && friendship.requested?

    # friendship is pending so accept it
    if friendship && friendship.pending?
      friendship.accept!
      request.accept!

      return friendship, Friendship::STATUS_FRIENDSHIP_ACCEPTED
    end

    # we didn't find a friendship, so let's create one!
    friendship = self.friendships.create(:friend_id => friend.id, :status => 'requested')

    # we didn't find a friendship request, so let's create it!
    request = friend.friendships.create(:friend_id => id, :status => 'pending')

    return friendship, Friendship::STATUS_REQUESTED

  end

  def friends?(friend)
    friendship = friendship_for(friend)
    friendship && friendship.accepted? 
  end

  def friendship_for(friend)
    friendships.where(friend_id: friend.id).first
  end

  def is?(friend)
    self.id == friend.id
  end

  def friends
    User.in(id: friend_ids)
  end

  def friend_ids
    self.friendships.where(status: 'accepted').pluck(:friend_id).to_a
  end

  def pending_friends
    pending_friend_ids = self.friendships.where(status: 'pending').pluck(:friend_id).to_a
    User.in(id: pending_friend_ids)
  end

  def delete_friend(friend)
    self.friendships.where(friend_id: friend.id).delete_all
    friend.friendships.where(friend_id: self.id).delete_all
  end


  private
    def destroy_all_friendships
      Friendship.where(user_id: id).delete_all
      Firendship.where(friend_id: id).delete_all
    end

end
