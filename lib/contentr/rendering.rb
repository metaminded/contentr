module Contentr
  module Rendering

    def render(*args, &block)
      # Check the request path
      path = request.env['PATH_INFO']
      return redirect_to contentr_url(:path => Contentr.default_page) if path.blank?

      # Do we try to render a /cms page or a normal controller action
      cms_rendering = path.starts_with?(Contentr.frontend_route_prefix)

      # Ok, lets render
      options = contentr_normalize_options(*args, &block)
      cms_rendering ? contentr_render_cms_page(path, options)
                    : contentr_render_default_page(path, options)
    end

    protected

    def contentr_render_cms_page(path, options)
      page = Contentr::Page.find_by_path(path)
      if page.present? and page.published?
        if page.is_link?
          redirect_to page.url_for_linked_page
        else
          @_contentr_current_page = page
          options = options.merge(:template => page.template, :layout => "layouts/contentr/#{page.layout}")
          self.response_body = render_to_body(options)
        end
      else
        raise ActionController::RoutingError.new(path)
      end
    end

    def contentr_render_default_page(path, options)
      page = Contentr::Page.find_linked_page_by_request_params(params)
      if page.present? and page.published?
        @_contentr_current_page = page
        layout = contentr_layout || "layouts/contentr/#{page.layout}"
        options = options.merge(:layout => layout)
      end
      self.response_body = render_to_body(options)
    end

    def contentr_normalize_options(*args, &block)
      # TODO: Not nice to use 'private' API I think
      options = _normalize_args(*args, &block)
      _normalize_options(options)
      options
    end

    def contentr_layout
      false
    end

  end
end