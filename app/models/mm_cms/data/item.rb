class MmCms::Data::Item

  # Includes
  include Mongoid::Document

  # Fields & Relations
  field :name,  :index => true
  field :value, :type => String # may be overidden in subclasses
  embedded_in :item, :class_name => 'MmCms::Item', :inverse_of => :data

  # Validations
  validates_presence_of :name
  validates_presence_of :value

  # Objects string representation
  def to_s
    value.to_s
  end

  # Objects liquid representation
  def to_liquid
    to_s
  end

  # The data type
  # Make sure you implement this on subclasses
  def type
    raise "Not implemented"
  end

  validate :moo
  def moo
    puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    errors.add(:xxx, 'moooo') if name == 'message'
  end

end
