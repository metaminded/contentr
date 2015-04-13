module Contentr
  class Menu < ActiveRecord::Base
    include MenuExtension
    prepend PrependedMenuExtension

    has_many :nav_points, dependent: :destroy
    accepts_nested_attributes_for :nav_points, allow_destroy: true

    validates :sid, presence: true, uniqueness: true

    def cache_key(user = nil)
      c_key =  <<-CACHEKEY.strip_heredoc.delete("\n")
        Contentr::Menu-#{id}-#{I18n.locale}-#{updated_at.to_i}-
        #{nav_points.sort_by(&:updated_at).reverse!.first.try(:updated_at).to_i}-
        #{nav_points.length}
      CACHEKEY
      c_key
    end
  end
end
