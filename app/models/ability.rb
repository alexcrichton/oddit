class Ability
  include CanCan::Ability

  def initialize user
    alias_action :search, :home, :to => :read

    can :read, [User, Major, Course]

    return if user.nil?

    can [:add_major, :remove_major, :update_major], User

    can :create, Major
    can :update, Major, :user_id => user.id
    can :clone, Major
    can :manage, user
    can :manage, Semester, :user => user

    cannot :sync, Semester, :scheduleman_id => nil
    cannot :sync, Semester, :scheduleman_id => ''
  end
end
