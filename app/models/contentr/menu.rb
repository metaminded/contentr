module Contentr
  class Menu < ActiveRecord::Base
    include MenuExtension

    has_many :nav_points, dependent: :destroy
    accepts_nested_attributes_for :nav_points, allow_destroy: true

    validates :sid, presence: true, uniqueness: true
  end
end
