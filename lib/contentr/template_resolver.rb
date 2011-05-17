# coding: utf-8

class Contentr::TemplateResolver < ActionView::FileSystemResolver

  def initialize
    super(File.join(Rails.root, 'app', 'views-contentr'))
  end

private

  #def find_templates(name, prefix, partial, details)
  #  puts "Name   : #{name}"
  #  puts "Prefix : #{prefix}"
  #  puts "Partial: #{partial}"
  #  puts "Details: #{details}"
  #
  #  path = ::ActionView::Resolver::Path.build(name, prefix, partial)
  #  puts "PATH   : #{path}"
  #  query(path, details, details[:formats])
  #end

end