module Contentr
  module Contentrable
    extend ActiveSupport::Concern

    included do
      has_many :generated_pages, class_name: 'Contentr::Page', as: :displayable
      has_one :default_page, ->{ where(page_in_default_language_id: nil)}, class_name: 'Contentr::Page', as: :displayable
      after_save :create_pages_for_object, if: :id_changed? 
    end

    def sub_pages
      self.default_page.try(:children)
    end

    def sub_pages=(pages)
      raise 'No default page available' unless self.default_page.present?
      self.default_page.children = sub_pages
    end

    def sub_pages?
      self.default_page.try(:children?)
    end

    def generated_page_for_locale(locale)
      page_to_display = self.generated_pages.find_by(language: locale.to_s)
      if page_to_display.nil?
        page_to_display = self.default_page
      end
      page_to_display
    end

    def sub_page_for_slug(slug)
      possible_pages = self.default_page.children.where(slug: slug)
      page_to_display = possible_pages.find{|pp| pp.language == I18n.default_locale.to_s}
      if page_to_display.nil?
        page_to_display = possible_pages.find{|pp| pp.page_in_default_language_id.nil?}
      end
      page_to_display
    end

    def create_pages_for_object
      page_builder = Contentr::PageBuilder.new
      page_builder.obj = self
      provided_options = self.class.instance_variable_get('@_provided_page_options')
      if provided_options.present?
        page_builder.page_options = provided_options
      end
      if self.class.instance_variable_get('@_provided_pages_block').present?
        page_builder.instance_exec(self, &self.class.instance_variable_get('@_provided_pages_block'))
      end
    end

    module ClassMethods
      def provided_pages page_type: nil, layout: 'application', &block
        @_provided_pages_block = block
        @_provided_page_options = {page_type: page_type, layout: layout}
      end
    end # ClassMethods
  end
end
