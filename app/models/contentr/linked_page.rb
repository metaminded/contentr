module Contentr
  class LinkedPage < Page

    # Includes
    include Rails.application.routes.url_helpers

    # Protect attributes from mass assignment
    attr_accessible :linked_to

    # Validations
    validates_presence_of   :linked_to
    validates_uniqueness_of :linked_to


    # Public: find a LinkedPage by specific parameters
    #
    # params - A hash containing the following keys:
    #   controller
    #   action
    #   id (optional)
    #
    # Returns the found LinkedPage
    def self.find_by_request_params(params)
      controller = params[:controller]
      action     = params[:action]
      id         = params[:id]

      return if controller.blank?
      return if action.blank?

      wildcard_pattern = "#{controller}#*"
      default_pattern = "#{controller}##{action}"
      full_pattern = "#{default_pattern}:#{id}" if id.present?

      if full_pattern.present?
        page = LinkedPage.where(linked_to: full_pattern).try(:first)
        return page if page.present?
      end

      page = LinkedPage.where(linked_to: default_pattern).try(:first)
      return page if page.present?

      page = LinkedPage.where(linked_to: wildcard_pattern).try(:first)
      return page if page.present?
    end

    # Public: generate a url by the string given in the linked_to attribute
    # 
    # Returns the url of the linkedPage or the rootUrl if non could be found
    def url
      begin
        if (linked_to.match(/:\/\/|^\//))
          url_for(linked_to)
        else
          p = linked_to.split('#')

          controller = p.first
          controller = "/#{controller}" unless controller.include?('/')

          action, id = p.last.split(':')
          action = 'index' if action.blank? or action.strip == '*'

          options = {}
          options = options.merge(controller: controller, action: action, only_path: true)
          options = options.merge(id: id) if id.present?

          url_for(options)
        end
      rescue => e
        logger.error e.message
        logger.error e.backtrace.join("\n")
        # in case we could not create a proper backlink url we will silently
        # fail with the app's root url.
        root_url(only_path: true)
      end
    end
  end
end
