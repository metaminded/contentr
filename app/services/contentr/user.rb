module Contentr
  class User
    def contentr_authorized?(options)
      false
    end

    def self.current(new_user = nil)
      if new_user
        @_contentr_current = new_user
      else
        @_contentr_current ||= new
      end
      @_contentr_current
    end

    def allowed_to_interact_with_contentr?
      false
    end

    def allowed_to_use_paragraphs?(area:, subject: nil)
      false
    end
  end
end