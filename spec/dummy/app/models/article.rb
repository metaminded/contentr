class Article < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :body

  attr_accessible :title, :body
end
