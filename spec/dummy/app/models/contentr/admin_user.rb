module Contentr
  class AdminUser < User
    def contentr_authorized?(type:, object:)
      true
    end

    def allowed_to_use_paragraphs?(area:, subject: nil)
      true
    end
  end
end