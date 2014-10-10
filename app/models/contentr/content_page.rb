module Contentr
  class ContentPage < Page
    include ContentPageExtension
    prepend PrependedContentPageExtension

    belongs_to :menu

    before_destroy :remove_navpoints

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
