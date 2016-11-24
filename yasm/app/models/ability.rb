class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :read, :all

    if user.has_role? :user
      can :manage, Site, :user_id => user.id
      can :manage, Page, :id => user.id

      can :create, Comment
      can :manage, Comment, :user_id => user.id
    end

    if user.has_role? :admin
      can :manage, :all
    end
  end
end
