class MmCms::Liquid::Tags::Lorem < ::Liquid::Tag

  Syntax = /(\d+)\s+(\w+)/

  def initialize(tag_name, markup, tokens)
    if markup =~ Syntax
      @count = $1.to_i
      @type  = $2
    else
      raise SyntaxError.new("Syntax Error in 'lorem' - Valid syntax: lorem [count] ['chars' | 'words' | 'paragraphs']")
    end

    super
  end

  def render(context)
    ::Lorem::Base.new(@type, @count).output
  end

end

::Liquid::Template.register_tag('lorem', MmCms::Liquid::Tags::Lorem)