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
    can :manage, RequirementGroup, :major => {:user_id => user.id}
    can :manage, Requirement, :requirement_group => {
      :major => {:user_id => user.id} }
    can :update, Major, :user_id => user.id
    can :destroy, Major, :user_id => user.id, :user_count => 0

    can :manage, user
    can :manage, Semester, :user => user # semesters are embedded, no user_id
    cannot :sync, Semester, :scheduleman_id => nil
    cannot :sync, Semester, :scheduleman_id => ''
  end
end
