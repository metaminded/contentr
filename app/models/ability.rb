class Ability
  include CanCan::Ability

  def initialize(user, params, controller=nil)
    can :manage, :all
  end

end
