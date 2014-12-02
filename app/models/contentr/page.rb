# coding: utf-8

module Contentr
  class Page < ActiveRecord::Base
    include PageExtension

    # Relations
    has_many :paragraphs, class_name: 'Contentr::Paragraph', dependent: :destroy
    belongs_to :displayable, polymorphic: true
    belongs_to :page_type, class_name: 'Contentr::PageType'
    belongs_to :page_in_default_language, class_name: 'Contentr::Page'
    has_many :sub_nav_items, class_name: 'Contentr::NavPoint', foreign_key: :parent_page_id, dependent: :destroy
    has_many :pages_in_foreign_languages, class_name: 'Contentr::Page', foreign_key: :page_in_default_language_id, dependent: :destroy

    acts_as_tree

    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates :language, inclusion: FormTranslation.languages.map(&:to_s)

    # validates_format_of     :slug, with: /\A[a-z0-9\s-]+\z/
    # validates_presence_of   :path
    # validates_uniqueness_of :path, allow_nil: false, allow_blank: false

    validate :unique_url

    # Callbacks
    before_validation :generate_slug
    before_validation :clean_slug
    after_save        :path_rebuilding
    before_destroy    :remove_navpoints

    attr_accessor :in_preview_mode

    # Public: Raises an error if url_path is set directly
    #
    # value - the new value of url_path
    #
    # Returns a runtime error
    def url_path=(value)
      raise "url_path is generated and can't be set manually." unless self.class.to_s == 'Contentr::LinkedPage'
      super
    end

    # Public: Checks if a page is visible
    #
    # Returns if visable or not
    def visible?
      self.published?
    end

    # Public: Searches for all paragraphs with an exact area_name
    #
    # area_name - the area_name to search for
    #
    # Returns the matching paragraphs
    def paragraphs_for_area(area_name, inherit: true)
      paragraphs = self.paragraphs.where(area_name: area_name).order('position asc')
      if paragraphs.none? && page_in_default_language.present? && inherit
        paragraphs = page_in_default_language.paragraphs.where(area_name: area_name).order('position asc')
      end
      if self.in_preview_mode
        paragraphs = paragraphs.map(&:for_edit)
      end
      paragraphs
    end

    def preview!
      self.in_preview_mode = true
    end

    def url
      if self.page_in_default_language.present?
        PathMapper.locale = self.language
        current_page = self.page_in_default_language
      else
        current_page = self
      end
      url_path = "#{current_page.path.includes(:displayable).select{|p| p.displayable || p.id == current_page.id}.collect(&:url_map).compact.join('/')}".squeeze('/')
      PathMapper.locale = nil
      url_path
    end

    def parent_url
      if self.page_in_default_language.present?
        PathMapper.locale = self.language
        current_page = self.page_in_default_language
      else
        current_page = self
      end
      url_path = current_page.ancestors.includes(:displayable).select{|p| p.displayable || p.id == current_page.id}.collect(&:url_map).compact
      if current_page.displayable.nil? && current_page.parent.present? && current_page.parent.displayable.present?
        url_path << Contentr.divider_between_page_and_children
      end
      PathMapper.locale = nil
      url_path.join('/').squeeze('/')
    end

    def url_map
      if self.displayable.present?
        p = PathMapper.new(self.displayable)
        p.path
      elsif self.parent.try(:displayable).present?
        [Contentr.divider_between_page_and_children, self.url_path].join('/').squeeze('/')
      else
        self.url_path
      end
    end

    def url_slug
      if self.displayable.present?
        nil
      else
        self.slug
      end
    end

    def preview_path
      params = {preview: true}.to_query
      params = self.url['?'] ? params.prepend('&') : params.prepend('?')
      "#{self.url}#{params}".squeeze('?').squeeze('&').squeeze('/')
    end

    def areas
      if self.page_type.present?
        self.page_type.areas
      else
        []
      end
    end

    def menu
      nil
    end

    def publish!
      self.paragraphs.each(&:publish!)
      self.update(published: true)
    end

    def hide!
      self.update(published: false)
    end

    def get_page_for_language(language, fallback: true)
      return self if self.language == language.to_s
      translated_page = self.pages_in_foreign_languages.includes(:paragraphs).find_by(language: language.to_s)
      translated_page || (fallback ? self : nil)
    end

    def default_page
      self.page_in_default_language.present? ? self.page_in_default_language : self
    end

    def self.default_page_for_slug(slug)
      self.find_by(slug: slug, page_in_default_language_id: nil)
    end

    def viewable?(preview_mode: false)
      self.present? && (self.visible? || preview_mode)
    end

    protected

    # Protected: Generates a slug from the name if a slug is not yet set
    #
    # Returns a clean slug
    def generate_slug
      if name.present? && slug.blank?
        self.slug = name.to_s.to_slug
      end
    end

    # Protected: Removes unwanted chars from a slug
    #
    # Returns a clean slug
    def clean_slug
     self.slug = slug.to_s.to_slug unless slug.blank?
    end

    # Protected: Builts the url_path from ancestry's path
    #
    # Updates the url_path of the caller
    def path_rebuilding
      if self.displayable.nil?
        self.subtree.each do |page|
          page.rebuild_path!
        end
      end
    end

    def rebuild_path!
      local_path = self.path.reject{|p| p.is_a?(Contentr::LinkedPage)}
      new_path = "#{local_path.collect(&:url_slug).compact.join('/')}".gsub(/\/+/, '/')
      new_path = new_path.prepend('/') unless new_path.start_with?('/')
      self.update_column(:url_path,  new_path) if self.displayable.nil?
    end

    def remove_navpoints
      Contentr::NavPoint.destroy_all(page: self)
    end

    def unique_url
      cnt = self.siblings.where.not(type: 'Contentr::LinkedPage')
              .where.not(id: self.id)
              .where(slug: self.slug)
              .select{|s| s.url == self.url}.count
      errors.add(:slug, :must_be_unique) if cnt > 0
    end

  end
end
