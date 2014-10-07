# coding: utf-8

module Contentr
  class Site < Page

    has_many :nav_points, class_name: 'Contentr::NavPoint', dependent: :destroy

    validate :has_no_parent

    # Node checks
    self.accepted_parent_nodes = [:root]
    self.accepted_child_nodes  = [Contentr::Page]

    # Public: Gets the default site
    #
    # Returns the default site from the db
    def self.default
      self.find_or_create_by!(slug: Contentr.default_site, name: Contentr.default_site, language: I18n.default_locale.to_s)
    end

    # Public: Gets the default_page
    #
    # Returns the first children of the caller
    def default_page
      self.children.first
    end

    def navigation
      self.nav_points.select{|n| n.parent.nil?}.first.subtree.arrange(order: :position)
    end

    def url_map
      nil
    end

    def url_slug
      nil
    end

    def rebuild_path!
    end

    private

    def has_no_parent
      errors.add(:parent, :must_not_be_set) if self.parent.present?
    end

  end
end
