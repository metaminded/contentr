module Features
  module SessionHelpers
    def login_as_admin
      Contentr::User.current(Contentr::AdminUser.new)
    end
  end
end


