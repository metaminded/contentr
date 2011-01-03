class MmCms::Data::StringData < MmCms::Data::Item

  # Fields & Relations
  field :value, :type => String

  def type
    'string'
  end

end
