module Contentr
  class Menu < ActiveRecord::Base
    include Etikett::Taggable

    has_many_via_tags :context, class_names: ['Council', 'Course', 'Faculty', 'Facility', 'Global']
    has_many :nav_points, dependent: :destroy
    accepts_nested_attributes_for :nav_points, allow_destroy: true

    validates :sid, presence: true, uniqueness: true
  end
end
