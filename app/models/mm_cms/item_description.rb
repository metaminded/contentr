module MmCms
  class ItemDescription
    
    def init(name, descr)
      raise "Name must be simple" unless /^[a-z_A-Z0-9]+$/.match(name)
      raise "ItemDescription must specify 'fields'" unless description['fields']
      @name        = name
      @label       = descr['label'] || raise "ItemDescription must specify a 'label'"
      @description = descr['description'] || raise "ItemDescription must specify a 'description'"
      @fields      = descr['fields'].map { |nam,d| ItemDataDescription.new(nam, d) }
    end

    def self.read_models
      mfiles = Dir.glob("#{RAILS_ROOT}/public/mm_cms/model/*.yml")
      @@models = mfiles.map do |mf| 
        YAML.load_file(mf) 
      end.inject({}) do |p,h| 
        p.merge h 
      end.map |k,v|
        ItemDescription.new(k, v)
      end
    end
  end
  
  class ItemDataDescription 
    def init(name, descr)
      raise "Name must be simple" unless /^[a-z_A-Z0-9]+$/.match(name)
      @name        = name
      @label       = descr['label'] || raise "ItemDataDescription must specify a 'label'"
      @description = descr['description'] || raise "ItemDataDescription must specify a 'description'"
      @type        = descr['type'] || raise "ItemDataDescription must specify a 'label'"
      raise "Wrong type '#{@type}'" unless %w{BigDecimal Boolean Date DateTime Float Integer String Time}.member? @type 
      @required    = descr['required'] and %w{yes ja true 1 please yup yeah}.member? descr['required'].downcase
      @format      = descr['format'] ? Regexp.new(descr['format']) : nil
      @min_value   = descr['min_value']
      @max_value   = descr['max_value']
  end
end