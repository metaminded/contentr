module Contentr
  class ContentPage < Page
    include ContentPageExtension
    prepend PrependedContentPageExtension

    belongs_to :menu

    before_destroy :remove_navpoints

    accepts_nested_attributes_for :pages_in_foreign_languages, allow_destroy: true

    def url
      "/pages/#{self.slug}"
    end

    def parent_url
      "/pages/"
    end

    def remove_navpoints
      NavPoint.destroy_all(page: self)
    end
  end
end
