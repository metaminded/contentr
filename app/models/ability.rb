class Ability
  include CanCan::Ability

  def initialize(user, params, controller=nil)
    cannot :manage, :all
  end

end
