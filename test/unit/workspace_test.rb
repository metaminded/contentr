# coding: utf-8

require 'test_helper'

class WorkspaceTest < ActiveSupport::TestCase

  def setup
    clean_mongodb
  end

  test 'create workspace' do
    workspace = Contentr::Workspace.create!(name: 'workspace1')
    assert workspace
  end

  test 'workspace must always be a root node' do
    flunk("Implement me")
    #node = Contentr::Node.create!(name: 'Node1')
    #assert_raise Contentr::UnsupportedParentNodeError do
    #  Contentr::Workspace.create!(name: 'workspace1', parent: node)
    #end
  end

  test 'workspaces can only have page childs' do
    flunk("Implement me")
    #workspace = Contentr::Workspace.create!(name: 'workspace1')
    #assert_raise Contentr::UnsupportedChildNodeError do
    #  Contentr::Node.create!(name: 'node', parent: workspace)
    #end
  end

end
