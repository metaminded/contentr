# coding: utf-8

require 'test_helper'

class NodeTreeTest < ActiveSupport::TestCase

  #
  # Node1
  #   Node11
  #   Node12
  # Node2
  #   Node21
  #     Node211
  #     Node212
  #   Node22
  #     Node221
  # Node3
  #   Node31
  #
  def setup

    node1 = Contentr::Node.create!(name: 'Node1')
    node2 = Contentr::Node.create!(name: 'Node2')
    node3 = Contentr::Node.create!(name: 'Node3')

    node11 = Contentr::Node.create!(name: 'Node11', parent: node1)
    node12 = Contentr::Node.create!(name: 'Node12', parent: node1)
    node21 = Contentr::Node.create!(name: 'Node21', parent: node2)
    node22 = Contentr::Node.create!(name: 'Node22', parent: node2)
    node31 = Contentr::Node.create!(name: 'Node31', parent: node3)

    node211 = Contentr::Node.create!(name: 'Node211', parent: node21)
    node212 = Contentr::Node.create!(name: 'Node212', parent: node21)
    node221 = Contentr::Node.create!(name: 'Node221', parent: node22)
  end

  test 'root nodes' do
    root_nodes = Contentr::Node.roots()
    assert root_nodes
    assert_equal 3, root_nodes.count
    assert_equal "Node1", root_nodes[0].name
    assert_equal "Node2", root_nodes[1].name
    assert_equal "Node3", root_nodes[2].name
  end

  test 'parent and children relation' do
    node = Contentr::Node.where(name: "Node21").first
    assert node

    # children
    assert node.children
    assert_equal "Node211", node.children[0].name
    assert_equal "Node212", node.children[1].name

    # parent
    assert_equal "Node21", node.children[0].parent.name
    assert_equal "Node21", node.children[1].parent.name
    assert_equal "Node2", node.parent.name
  end

  test "parent ids" do
    node = Contentr::Node.where(name: "Node212").first
    assert node
    assert_equal [node.parent.parent.id, node.parent.id], node.ancestor_ids
  end

  test "change parent" do
    node211 = Contentr::Node.where(name: "Node211").first
    node21  = Contentr::Node.where(name: "Node21").first
    node2   = Contentr::Node.where(name: "Node2").first
    node3   = Contentr::Node.where(name: "Node3").first

    assert_equal node21, node211.parent
    assert_equal node2, node21.parent
    assert_equal [node2.id, node21.id], node211.ancestor_ids
    assert_equal '/node2/node21/node211', node211.url_path

    # move node21 to it's new parent node3
    node21.parent = node3
    node21.save!
    node211.reload

    assert_equal [node3.id, node21.id], node211.ancestor_ids
    assert_equal '/node3/node21/node211', node211.url_path
  end

end
