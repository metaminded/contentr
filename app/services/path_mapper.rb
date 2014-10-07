class PathMapper < Struct.new(:obj)
  cattr_accessor :locale
  include Rails.application.routes.url_helpers

  def path
    self.send "#{obj.class.name.underscore}_map"
  end

  def article_map
    article_path(obj, locale: PathMapper.locale || I18n.locale)
  end
end
