class Ability
  include CanCan::Ability

  def initialize(user)
    if user.blank?
      basic_read_only
    else
      user ||= User.new
      if user.admin?
        can :manage, :all
      end    

      can [:edit, :update, :destroy], Post, :user_id => user.id
      can [:edit, :update, :destroy], Topic, :user_id => user.id
      can [:read], Bike, :user_id => user.id
      cannot [:destroy, :update], User, :id => user.id

      can :create, Post
      can :create, Topic

      can :read, Media, :user_id => user.id

      basic_read_only
    end
  end

  private
    def basic_read_only
      can :read, Topic 
      can :read, Article
    end
end
