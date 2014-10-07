# coding: utf-8

class String

  def to_slug
    s = self.dup.force_encoding("utf-8")
    s.downcase!
    s = I18n.transliterate(s)
    s.gsub!('_', '-')
    # s.gsub!(/[^a-z0-9\s-]/, '') # Remove non-word characters
    s.gsub!(/\s+/, '-')         # Convert whitespaces to dashes
    s.gsub!(/-\z/, '')          # Remove trailing dashes
    s.gsub!(/-+/, '-')          # get rid of double-dashes
    s.gsub!(/[&\?]/, '')
    s.strip!
    s
  end

end
