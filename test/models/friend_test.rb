require 'test_helper'

class FriendTest < ActiveSupport::TestCase
  def setup
    @vader    = create(:user)
    @luke     = create(:user)
    @leia     = create(:user)
    @han_solo = create(:user)
    @yoda     = create(:user)
  end

  test 'User should respond to has_friends method' do
    assert_respond_to @yoda, :be_friends_with
    assert_respond_to @yoda, :friends? 
  end

  test 'friends should work' do
    create_friendship(@vader, @luke)
    create_friendship(@vader, @leia)
    create_friendship(@luke,  @leia)
    create_friendship(@luke,  @yoda)
    create_friendship(@leia,  @han_solo)

    assert_equal [@luke, @leia], @vader.friends
    assert_equal [@leia, @luke], @vader.friends.order(name: :desc)

    assert_equal [@vader, @luke, @han_solo], @leia.friends
    assert_equal [@luke], @yoda.friends

    assert_equal [@leia], @han_solo.friends
  end

  test 'delete friend should work' do
    create_friendship(@vader, @luke)
    create_friendship(@vader, @leia)
    create_friendship(@luke,  @leia)
    create_friendship(@luke,  @yoda)
    create_friendship(@leia,  @han_solo)

    @vader.delete_friend(@luke)

    assert_not @vader.friends?(@luke)
    assert_not @luke.friends?(@vader)

    assert @luke.friends?(@leia)
  end

  test 'friendship request should return nil and friend is required status when user calls friend with nil' do
    friendship, status = @vader.be_friends_with(nil)
    assert_nil friendship
    assert_equal Friendship::STATUS_FRIEND_IS_REQUIRED, status
  end

  test 'friendship request should return nil and friend is you status when user calls friend with self' do
    friendship, status = @vader.be_friends_with(@vader)
    assert_nil friendship
    assert_equal Friendship::STATUS_IS_YOU, status
  end

  test 'friendship request should return nil and friend is already friends status when user calls friend with his friend' do
    @vader.be_friends_with(@luke)
    @luke.be_friends_with(@vader)

    friendship, status = @vader.be_friends_with(@luke)
    assert_nil friendship
    assert_equal Friendship::STATUS_ALREADY_FRIENDS, status
  end
  
  test 'friendship request should return nil and friend is already requested status when user calls friend request again' do
    @vader.be_friends_with(@luke)

    friendship, status = @vader.be_friends_with(@luke)
    assert_nil friendship
    assert_equal Friendship::STATUS_ALREADY_REQUESTED, status
  end

  test 'friendship request should return friendship  and friend is accepted status when two users both call friend request' do
    @vader.be_friends_with(@luke)

    friendship, status = @luke.be_friends_with(@vader)
    assert friendship
    assert_kind_of Friendship, friendship
    assert_equal Friendship::STATUS_FRIENDSHIP_ACCEPTED, status

    assert @vader.friends?(@luke)
    assert @luke.friends?(@vader)
  end

  private
    def create_friendship(user1, user2)
      user1.be_friends_with(user2)
      user2.be_friends_with(user1)
    end
end
