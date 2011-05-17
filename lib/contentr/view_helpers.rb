module Contentr
  module Rendering
    module ViewHelpers

      def current_page
        @_contentr_current_page
      end

      #def contentr_area(area_name)
      #  link_name = request.env['PATH_INFO']
      #  page = Page.find_by_link(link_name)
      #  page ||= Page.find_by_link(link_name.gsub(params[:id], '*')) if params[:id]
      #  contentr_render_engine.render_paragraphs(page, area_name, controller, request) if page
      #end

      private

      #def contentr_render_engine
      #  @contentr_render_engine ||= Contentr::RenderEngine.new
      #end

    end
  end
end