module Contentr
  module ApplicationHelper

    # Renders an area of paragraphs
    #
    # @param [String] The name of the area that should be rendered.
    #
    def contentr_area(area_name)
      if area_name.present? and @contentr_page.present?
        contentr_render_area(area_name, @contentr_page, nil)
      end
    end

    # Renders an area of paragraphs for site paragraphs
    #
    # @param [String] The name of the area that should be rendered.
    #
    def contentr_site_area(area_name)
      if area_name.present? and @contentr_page.present?
        contentr_render_area(area_name, @contentr_page, Contentr::Site.default)
      end
    end

    # Renders the contentr toolbar in the page
    def contentr_toolbar(options = {})
      if @contentr_page.present? and controller.contentr_authorized?
        return render(
          partial: 'contentr/toolbar',
          locals: {
            page: @contentr_page
          }
        )
      end
    end

    # Inserts Google Anylytics into the page
    def contentr_google_analytics
      if Contentr.google_analytics_account.present?
        render(
          partial: 'contentr/google_analytics',
          locals: {
            account_id: Contentr.google_analytics_account
          }
        )
      end
    end

    private

    def contentr_render_area(area_name, current_page, site)
      area_name  = area_name.to_s
      authorized = controller.contentr_authorized?
      paragraphs = site.present? ? site.paragraphs_for_area(area_name) : current_page.paragraphs_for_area(area_name)

      render(
        partial: 'contentr/area',
        locals: {
          page: current_page,
          site: site,
          area_name: area_name,
          authorized: authorized,
          paragraphs: paragraphs
        }
      )
    end
  end
end