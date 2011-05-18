# coding: utf-8

class Contentr::TemplateResolver < ActionView::FileSystemResolver

  def initialize
    super(File.join(Rails.root, 'app', 'views-contentr'))
  end

private

  # If we need to be more intelligent on resolving
  # templates, override find_templates
  #def find_templates(name, prefix, partial, details)
  #
  #end

end