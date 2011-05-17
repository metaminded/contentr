require 'lorem'

class Contentr::LiquidSupport::Tags::Lorem < Liquid::Tag

  def initialize(tag_name, markup, tokens)
    if markup =~ /(\d+)\s+(\w+)/
      @count = $1.to_i
      @type  = $2
    else
      raise SyntaxError.new("Syntax Error in 'lorem' - Valid syntax: lorem [count] ['chars' | 'words' | 'paragraphs']")
    end

    super
  end

  def render(context)
    Lorem::Base.new(@type, @count).output
  end

end

Liquid::Template.register_tag('lorem', Contentr::LiquidSupport::Tags::Lorem)