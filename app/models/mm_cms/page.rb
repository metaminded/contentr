# coding: utf-8

module MmCms
  class Page < Node

    # Fields
    field :layout,   :type => String, :default => 'default'
    field :template, :type => String, :default => 'default'

    # Protect attributes from mass assignment
    attr_accessible :layout

    # Validation
    validates_presence_of  :layout
    validates_presence_of  :template
    validates_exclusion_of :name, :in => %w( admin )

    def to_liquid
      MmCms::Liquid::Drops::PageDrop.new(self)
    end

    validate :moo

    protected

    def moo
      errors[:base] << "This person is invalid because ..."
      errors.add(:page_data_value, 'dddd')
    end

  end
end
