class MmCms::Data::StringData < MmCms::Data::Item

  # Fields & Relations
  field :string_value

  # Validations
  validates_presence_of :string_value

  # Objects string representation
  def to_s
    string_value
  end

  # Objects liquid representation
  def to_liquid
    to_s
  end

end
