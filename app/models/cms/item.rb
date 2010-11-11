class Cms::Item

  # Includes
  include Mongoid::Document

  # Fields & Relations
  field :name, :index => true
  references_many :children, :class_name => 'Cms::Item', :foreign_key => :parent_id, :inverse_of => :parent
  referenced_in :parent, :class_name => 'Cms::Item', :inverse_of => :children, :index => true
  embeds_many :data, :class_name => 'Cms::Data::Item'

  # Validations
  validates_presence_of :name

  # Protect attributes
  attr_accessible :name, :parent

  #
  # /foo/bar/page
  #
  # TODO: Find item 'page' where page.parent
  #
  def self.find_by_path(path)
    # TODO: path ...
    Cms::Item.where(:name => path).first
  end

end
