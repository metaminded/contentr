class DatetimepickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    datetime = object.send(attribute_name)
    input_html_options[:value] = datetime.present? ? I18n.l(datetime, format: :form) : ''
    input_html_classes.push(:string, :'form-control')

    template.content_tag(:div, class: 'input-group datetime') do
      @builder.text_field(attribute_name, input_html_options) +
      template.content_tag(:span, class: 'input-group-addon') do
        template.content_tag(:span, class: 'fa fa-calendar'){}
      end
    end
  end
end
