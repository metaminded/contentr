module Contentr
  class User
    def self.current(new_user = nil)
      if new_user
        @_contentr_current = new_user
      else
        @_contentr_current ||= new
      end
      @_contentr_current
    end

    def allowed_to_use_paragraphs?(area: nil, paragraph_class: nil)
      false
    end
  end
end
