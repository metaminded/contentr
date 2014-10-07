class Article < ActiveRecord::Base
  include Contentr::Contentrable

  validates_presence_of :title
  validates_presence_of :body

  permitted_attributes :title, :body

  provided_pages do
    create ->(article){article.title}, for_object: true 
  end
end
