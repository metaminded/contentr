module Contentr
  class AdminUser < User
    def contentr_authorized?(type:, object:)
      true
    end

    def allowed_to_use_paragraphs?(area:, paragraph_class: nil)
      true
    end
  end
end