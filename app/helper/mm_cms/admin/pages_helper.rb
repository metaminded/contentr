module MmCms::Admin::PagesHelper

  def form_fields_for_data(form, page)
    content = ''.html_safe

    model = @page.model
    data = form.object

    if model.present? and data.present?
      data_description = model.get_description(data.name)
      if data_description.present?
        content << render("form_#{data.type}_data", :page => page, :data => data, :form => form, :data_description => data_description)
      end
    end

    content
  end

end