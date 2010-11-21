class MmCms::Data::Item

  # Includes
  include Mongoid::Document

  # Fields & Relations
  field :name, :index => true
  embedded_in :item, :class_name => 'MmCms::Item', :inverse_of => :data

  # Validations
  validates_presence_of :name

  # Objects string representation
  def to_s
    value.to_s
  end

  # Objects liquid representation
  def to_liquid
    to_s
  end

end
