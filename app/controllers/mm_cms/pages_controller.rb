# coding: utf-8

class MmCms::PagesController < MmCms::ApplicationController

  # Global filters, setup, etc.
  before_filter :setup_site, :setup_liquid

  # (Naive) template caching
  @@cached_templates = {}

  def show
    path = params[:path]
    return redirect_to cms_url(:path => @site.default_page_path) if path.blank?

    @item = MmCms::Page.find_by_path(path)
    @item.present? ? render_page : render_page_not_found
  end

protected

  def render_page
    render_liquid_template
  end

  def render_page_not_found
    render :text => "No such page", :status => 404
  end

  def setup_site
    @site = MmCms::Site.new # Site is a singleton. FIXME!!
  end

  #######################################################################################
  #
  # Liquid Support
  #
  #######################################################################################

  ##
  # Setup the Liquid template engine.
  #
  # @BeforeFilter
  #
  def setup_liquid
    Liquid::Template.file_system = Liquid::LocalFileSystem.new(@site.theme_name)
  end

  ##
  # Renders a Liquid template (for the current action) together
  # with a Liquid layout.
  #
  def render_liquid_template(options = {})
    # Merge the options hash with some useful defaults
    options = {
      :layout    => @item.layout,
      :template  => @item.template,
      :assigns   => {},
      :registers => {}
    }.merge(options)

    # override layout by request if available
    options[:layout] = params[:__layout] if params[:__layout].present?

    # Global assignments that are always available
    options[:assigns]['request_params'] = request.params
    options[:assigns]['item']           = @item
    options[:assigns]['site']           = @site

    # Global registers that are always available
    options[:registers]['controller'] = self

    # Load the template identified by the given template name.
    template_file    = get_liquid_template(options[:template])
    template_content = template_file.render!(options[:assigns], { :registers => options[:registers] })
    options[:assigns]['content_for_layout'] = template_content

    # Load the Liquid layout file.
    layout_file      = get_liquid_template(options[:layout], true)
    layout_content   = layout_file.render!(options[:assigns], { :registers => options[:registers] })

    # Finally write out the result.
    render :text => layout_content
  end

  ##
  # Loads and parses the a Liquid template
  #
  def get_liquid_template(name, layout = false)
    t = load_liquid_template(name, layout)
    if t
      # TODO: Improve caching
      if ENV["RAILS_ENV"] == "production"
        cache_key = name + '_' + layout.to_s
        if @@cached_templates.has_key?(cache_key)
          return @@cached_templates[cache_key]
        else
          pt = Liquid::Template.parse(t)
          @@cached_templates[cache_key] = pt
          return pt
        end
      else
        return Liquid::Template.parse(t)
      end
    end
  end

  ##
  # Loads a Liquid template for the current account from
  # the file system.
  #
  def load_liquid_template(name, layout = false)
    raise "Illegal template name '#{name}'" unless name =~ /^[a-zA-Z0-9_]+$/

    # override theme by request if available
    theme_name = params[:__theme] if params[:__theme].present?
    theme_path = theme_name.present? ? File.join(@site.themes_path, theme_name) : @site.theme_path

    # load the template
    liquid_template = File.join(theme_path, layout ? "#{name}.layout" : "#{name}.template")
    raise "No such template file #{liquid_template}" unless File.exists?(liquid_template)

    File.read(liquid_template)
  end

end