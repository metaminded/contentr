require 'test_helper'

class NodeTest < ActiveSupport::TestCase

  test 'create a single page' do
    page = Contentr::Page.create!(:name => 'Some Page')
  end

end