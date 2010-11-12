class MmCms::Data::Item

  # Includes
  include Mongoid::Document

  # Fields & Relations
  field :name, :index => true
  embedded_in :item, :class_name => 'MmCms::Item', :inverse_of => :data

  # Validations
  validates_presence_of :name

end
