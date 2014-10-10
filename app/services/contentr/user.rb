module Contentr
  class User
    def authorized?(options)
      false
    end

    def self.current
      @_contentr_current ||= new
    end
  end
end