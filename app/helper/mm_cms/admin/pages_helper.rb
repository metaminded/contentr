module MmCms::Admin::PagesHelper

  def data_form_fields_for(form, page)
    c = ''.html_safe
    model = MmCms.page_model(page.template)
    if model.present?
      model.data_descriptions.each do |d|
        c << render("form_#{d.type}_data", :page => @page, :data_description => d, :form => form)
      end
    end
    c
  end

end