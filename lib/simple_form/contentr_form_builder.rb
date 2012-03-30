class ContentrFormBuilder < SimpleForm::FormBuilder
  def input(attribute_name, options = {}, &block)
    options[:input_html].merge! :class => 'custom'
    super
  end
end