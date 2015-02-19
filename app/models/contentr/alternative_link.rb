module Contentr
  class AlternativeLink < ActiveRecord::Base
    belongs_to :page, class_name: 'Contentr::Page'
    belongs_to :nav_point, class_name: 'Contentr::NavPoint', touch: true

    validates :language, presence: true

  end
end