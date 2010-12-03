module MmCms

  ##
  # TBD
  #
  class Item
    # Includes
    include Mongoid::Document

    # Fields & Relations
    field :name,        :type => String
    field :description, :type => String
    field :slug,        :type => String,  :index => true
    embeds_many :data, :class_name => 'MmCms::Data::Item' do
      def get(name)
        @target.select { |data| data.name == name }.first
      end
    end

    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates_uniqueness_of :slug

    # Protect attributes from mass assignment
    attr_accessible :name, :description, :parent

    # Callbacks
    before_validation :generate_slug

    def to_liquid
      MmCms::ItemLiquidProxy.new(self)
    end

  protected

    def generate_slug
      self.slug = name.to_url
    end

  end

  ##
  # TBD
  #
  class ItemLiquidProxy < ::Liquid::Drop

    def initialize(item)
      @item = item
    end

    def data
      MmCms::ItemDataLiquidProxy.new(@item.data)
    end

    def name
      @item.name
    end

    def description
      @item.description
    end

    def slug
      @item.slug
    end

  end

  ##
  # TBD
  #
  class ItemDataLiquidProxy < ::Liquid::Drop

    def initialize(data)
      @data = data
    end

    # method missing
    def before_method(m)
      @data.each { |d| return d if d.try(:name) == m }
      nil
    end
  end
end