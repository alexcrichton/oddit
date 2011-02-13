class Ability
  include CanCan::Ability

  def initialize user
    return if user.nil?

    can :manage, :all

    cannot :sync, Semester, :scheduleman_id => nil
    cannot :sync, Semester, :scheduleman_id => ''
  end
end
