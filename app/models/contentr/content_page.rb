module Contentr
  class ContentPage < Page
    include Etikett::Taggable

    belongs_to :menu

    after_find :remember_contexts
    after_save :generate_navpoints
    before_destroy :remove_navpoints

    has_many_via_tags :context, class_names: ['Council', 'Course', 'Faculty', 'Facility', 'Global']

    validates_presence_of   :context_tags

    master_tag inherited_from: 'Etikett::Contentr_PageTag' do
      {
        sid: name_with_prefix
      }
    end

    def url
      "/pages/#{slug_with_prefix}"
    end

    def parent_url
      "/pages/#{url_prefix}"
    end

    private

    def name_with_prefix
      prefix = self.url_prefix_tags.first.try(:name)
      prefix.present? ? "#{prefix} / #{self.name}" : self.name
    end

    def slug_with_prefix
      prefix = self.url_prefix_tags.first.try(:name)
      prefix.present? ? "#{prefix.parameterize}_#{self.slug}" : self.slug
    end

    def url_prefix
      prefix = self.url_prefix_tags.first.try(:name)
      prefix.present? ? "#{prefix.parameterize}_" : ''
    end

    def remember_contexts
      @_context_tags = self.context_tags.to_a
    end

    def generate_navpoints
      # XOR on Tags before and after editing
      changed_tags = @_context_tags.to_a + self.context_tags.to_a - (@_context_tags.to_a & self.context_tags.to_a)
      changed_tags.each do |tag|
        menu = Menu.includes(:context_tags).find_by(etikett_tags: { id: tag.id })
        navpoint = NavPoint.find_by(page: self, menu: menu)
        # if present than destroy, otherwise create it
        if navpoint.present?
          navpoint.destroy
        else
          NavPoint.create(title: self.name, page: self, menu: menu, nav_point_type: 'menu_nav_point', visible: true)
        end
      end
    end

    def remove_navpoints
      NavPoint.destroy_all(page: self)
    end
  end
end
