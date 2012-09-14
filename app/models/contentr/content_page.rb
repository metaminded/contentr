module Contentr
  class ContentPage < Page

    # Fields
    # field :layout,   :type => String, :default => 'application'
    # field :template, :type => String, :default => 'default'

    # Protect attributes from mass assignment
    attr_accessible :layout, :template

    # Validations
    validates_presence_of :layout
    validates_presence_of :template
  end
end
