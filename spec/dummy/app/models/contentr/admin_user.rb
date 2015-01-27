module Contentr
  class AdminUser < User

    def allowed_to_use_paragraphs?(area: nil, paragraph_class: nil)
      true
    end
  end
end
