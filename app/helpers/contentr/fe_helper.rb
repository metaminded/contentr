module Contentr
  module FeHelper

    def contentr_toolbar(options = {})
      content_tag(:div, :class => 'contentr-fe toolbar') do
        link_to('#', 'mooo')
      end
    end

  end
end