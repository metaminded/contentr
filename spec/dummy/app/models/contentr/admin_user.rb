module Contentr
  class AdminUser < User
    def contentr_authorized?(options)
      true
    end

    def allowed_to_interact_with_contentr?
      true
    end
  end
end