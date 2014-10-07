module Contentr
  module Linkable
    extend ActiveSupport::Concern

    included do
    end

    def contentr_link_me linked_to: nil, append: "", object: nil
      @contentr_page = find_or_create_linked_page(linked_to, append, object, I18n.locale)
      @page_in_default_language = find_or_create_linked_page(linked_to, append, object, I18n.default_locale)
      if @contentr_page.language != @page_in_default_language.language
        if @page_in_default_language.language.to_s == I18n.default_locale.to_s && @contentr_page.page_in_default_language.nil?
          @contentr_page.update(page_in_default_language: @page_in_default_language)
        end
        if @contentr_page.paragraphs.none?
          flash.now[:notice] = t('contentr.content_not_available_in_language')
        end
      end
    end

    def contentr_context(object)
      raise "No Contentr Page available." unless @contentr_page
      if @contentr_page.displayable != object
        @contentr_page.displayable = object
        @contentr_page.save!
      end
      object
    end

    private

    def find_or_create_linked_page(linked_to, append, object, locale)
      linked_to ||= "#{locale}_#{self.class.name.underscore}##{action_name}"
      linked_to_page = linked_to + append
      Contentr::LinkedPage.includes(paragraphs: :content_block).find_or_create_by!(linked_to: linked_to_page) do |cp|
        cp.language = I18n.locale.to_s
        cp.name = linked_to_page
        cp.displayable = object
      end
    end

    module ClassMethods
    end
  end
end
