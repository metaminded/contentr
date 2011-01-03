class MmCms::Data::Item

  # Includes
  include Mongoid::Document

  # Fields & Relations
  field :name,  :index => true
  field :value, :type => String # may be overidden in subclasses
  embedded_in :item, :class_name => 'MmCms::Item', :inverse_of => :data

  # Validations
  validate :perform_model_validation
  validates_presence_of :name

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

  def model_validation_options=(options = {:required => false, :format => nil})
    @model_validation_options = options
  end

  def perform_model_validation
    if (@model_validation_options.present?)
      if (@model_validation_options[:required])
        errors.add(:value, "Can't be blank") if value.blank?
      end
    end
  end

end
