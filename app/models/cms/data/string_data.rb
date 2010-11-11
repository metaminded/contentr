class Cms::Data::StringData < Cms::Data::Item

  # Fields & Relations
  field :string_value

  # Validations
  validates_presence_of :string_value

  def to_s
    string_value
  end

end
