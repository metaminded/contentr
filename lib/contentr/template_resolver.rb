# coding: utf-8

class Contentr::TemplateResolver < ActionView::FileSystemResolver

  def initialize
    super(File.join(Rails.root, 'app', 'views'))
  end

private

  # If we need to be more intelligent on resolving
  # templates, override find_templates
  def find_templates(name, prefix, partial, details)
    # Modify the prefix in case we try to resolve partials within
    # the contentr scope£
    prefix = 'contentr' if partial
    super(name, prefix, partial, details)
  end

end