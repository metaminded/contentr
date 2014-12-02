module Contentr
  class LinkedPage < Page

    # Includes
    include Rails.application.routes.url_helpers
    include LinkedPageExtension

    def unique_url
      true
    end

    protected

    def path_rebuilding; end

  end
end
