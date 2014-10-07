module Contentr
  class NavPoint < ActiveRecord::Base
    include FormTranslation::ForModel

    belongs_to :site, class_name: 'Contentr::Site'
    belongs_to :page, class_name: 'Contentr::Page'
    belongs_to :parent_page, class_name: 'Contentr::Page'
    after_create :set_actual_position!

    belongs_to :menu

    validate :site, presence: true
    validate :url_xor_page

    translate_me :title

    default_scope -> { order('position asc') }
    scope :visible, ->() { where(visible: true).order('position asc') }

    acts_as_tree

    def only_link?
      self.page.nil?
    end

    def self.navigation_tree
      self.where(parent_page_id: nil, nav_point_type: [nil, 'nav_point']).includes(page: :page_in_default_language).arrange(order: :position)
    end

    def set_actual_position!
      if self.ancestry.present?
        last_position = self.siblings.where.not(id: self.id).reorder('position DESC').limit(1)
      else
        last_position = self.class.where(parent_page_id: self.parent_page_id).where.not(id: self.id).reorder('position DESC').limit(1)
      end
      if last_position.any?
        self.update_columns(position: last_position.first.position + 1)
      end
    end

    def link
      if self.page.present?
        self.page.url
      elsif self.url.present?
        self.url
      end
    end

    def self.navigation_roots
      roots.where(parent_page_id: nil, nav_point_type: [nil, 'nav_point']).order(position: :asc)
    end

    private

    def url_xor_page
      if [page, url].compact.select(&:present?).count > 1
        errors.add(:url, :page_and_url_are_mutual_exclusive)
      end
    end
  end
end
