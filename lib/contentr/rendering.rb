module Contentr
  module Rendering

    def render_to_body(options)
      @contentr_path = params[:contentr_path]

      if @contentr_path.present?
        #
        # Contentr rendering
        #
        path = ::File.join(Contentr.default_site, @contentr_path)
        @contentr_page = Contentr::Page.find_by_path(@contentr_path) || Contentr::Page.find_by_path(path)
        if @contentr_page.present? && (@contentr_page.published || contentr_authorized?) && !@contentr_page.menu_only?
          if @contentr_page.is_a?(Contentr::LinkedPage)
            return redirect_to @contentr_page.url, status: :moved_permanently
          else
            options[:template] = @contentr_page.template
            options[:layout]   = "layouts/#{@contentr_page.layout}"
          end
        else
          raise ActionController::RoutingError.new(@contentr_path)
        end
      else
        #
        # Default rendering - we need to check for linked pages
        # TODO: enable only for contentr aware controllers
        #
        @contentr_page ||= Contentr::LinkedPage.find_by_request_params(params)
      end

      super options
    end
  end
end
