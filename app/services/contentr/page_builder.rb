module Contentr
  class PageBuilder
    attr_accessor :parent, :page_options, :obj

    def initialize(hash = {})
      @parent = hash.fetch :parent, nil
      @page_options = hash.fetch :page_options, {}
      @obj = hash.fetch :obj, nil
    end

    def create name, slug: nil, en: nil, page_type: nil, publish: true, removable: false, for_object: false, displayable: nil, &block
      object_for_page = displayable || obj if for_object
      return if object_for_page.try(:default_page).present?
      ActiveRecord::Base.transaction do
        page_type = page_type.presence || Contentr::PageType.find_by(sid: page_options[:page_type])
        if name.respond_to?(:call)
          real_name = name.instance_exec(obj, &name)
        else
          real_name = name
        end
        page = Contentr::Page.new(name: real_name,
          language: FormTranslation.default_language.to_s,
          parent: self.parent,
          page_type: page_type,
          published: publish,
          layout: page_options[:layout],
          removable: false)
        page.displayable =  displayable || obj if for_object
        page.slug = slug if slug.present?
        page.save!
        if page.parent.present?
          Contentr::NavPoint.create!(title: real_name, page: page, parent_page: page.parent, en_title: en, removable: removable)
        end
        if block_given?
          page_builder = Contentr::PageBuilder.new(parent: page, page_options: self.page_options, obj: self.obj)
          page_builder.instance_exec(nil, &block)
        end
      end
    end
  end
end
