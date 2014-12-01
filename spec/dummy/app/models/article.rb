class Article < ActiveRecord::Base
  include Contentr::Contentrable

  provided_pages do |article|
    create ->(a){a.title}, for_object: true
  end
end
