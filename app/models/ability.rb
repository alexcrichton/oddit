class Ability
  include CanCan::Ability

  def initialize user
    alias_action :search, :to => :read

    can :read, [User, Major, Course]

    return if user.nil?

    # These actions are always on the current user, so specify the class as the
    # target instead of the user object
    can [:home, :add_major, :remove_major, :update_major], User

    can [:create, :clone], Major
    can :update, Major, :user_id => user.id
    can :manage, user
    can :manage, Semester, :user => user # semesters are embedded, no user_id

    cannot :sync, Semester, :scheduleman_id => nil
    cannot :sync, Semester, :scheduleman_id => ''
  end
end
