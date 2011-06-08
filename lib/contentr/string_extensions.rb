# coding: utf-8

class String

  def to_slug
    s = self.dup
    s.downcase!
    s.gsub!('ß', 'ss')
    s.gsub!('ä', 'ae')
    s.gsub!('ö', 'oe')
    s.gsub!('ü', 'ue')
    s.gsub!('_', '-')
    s.gsub!(/[^a-z0-9\s-]/, '') # Remove non-word characters
    s.gsub!(/\s+/, '-')         # Convert whitespaces to dashes
    s.gsub!(/-\z/, '')          # Remove trailing dashes
    s.gsub!(/-+/, '-')          # get rid of double-dashes
    s.strip!
    s
  end

end