# coding: utf-8

module MmCms
  class Page < Node

    # Fields
    field :layout,   :type => String, :default => 'default'
    field :template, :type => String, :default => 'default'

    # Protect attributes from mass assignment
    # attr_accessible :layout, :template

    # Validation
    validates_presence_of  :layout
    validates_presence_of  :template
    validates_exclusion_of :name, :in => %w( admin )

    def model
      mf = "#{Rails.root}/public/mm_cms/model/page/#{self.template.downcase}.yml"
      if (File.exists?(mf))
        PageModel.new(YAML.load_file(mf))
      end
    end

    def to_liquid
      MmCms::Liquid::Drops::PageDrop.new(self)
    end

  end

protected

  class PageDataDescription
    SUPPORTED_TYPES = %w{BigDecimal Boolean Date DateTime Float Integer String Text Time}
    attr_accessor :name, :label, :description, :type, :required, :format, :min_value, :max_value

    def initialize(name, descr)
      raise "Name must be simple" unless /^[a-z_A-Z0-9]+$/.match(name)
      @name        = name
      @label       = descr['label']       || raise("Page model must specify a 'label'")
      @description = descr['description'] || raise("Page model must specify a 'description'")
      @type        = descr['type']        || raise("Page model must specify a 'type'")
      raise "Wrong type '#{@type}'" unless SUPPORTED_TYPES.member?(@type)
      @type.downcase!
      @required    = descr['required']
      @format      = descr['format'] ? Regexp.new(descr['format']) : nil
      @min_value   = descr['min_value']
      @max_value   = descr['max_value']
    end
  end

  class PageModel
    attr_reader :data_descriptions

    def initialize(model)
      @data_descriptions = model.map do |name, desc|
          PageDataDescription.new(name, desc)
      end
    end

    def get_description(name)
      @data_descriptions.each do |d|
        return d if d.name.downcase == name.downcase
      end
      nil
    end
  end

end
