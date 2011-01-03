# coding: utf-8

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
    validates_associated    :data

    # Protect attributes from mass assignment
    attr_accessible :name, :description, :parent

    # Callbacks
    before_validation :generate_slug

    def to_liquid
      MmCms::Liquid::Drops::ItemDrop.new(self)
    end

    # Data attributes writer to allow fields_for work
    # with our embedded data array. We use this as a marker and
    # do not implement any function.
    def data_attributes=(attributes)
      puts "******************************** #{attributes.inspect}"
      return true
    end

  protected

    def generate_slug
      self.slug = name.to_url
    end

  end
end