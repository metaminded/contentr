# coding: utf-8

require 'spec_helper'

describe Contentr::Node do
  
  before(:all) do
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

  after(:all) do
    Contentr::Node.delete_all
  end


  its 'root nodes' do
    root_nodes = Contentr::Node.roots()
    root_nodes.should_not be_nil
    root_nodes.should have(3).items
    root_nodes[0].name.should eql "Node1"
    root_nodes[1].name.should eql "Node2"
    root_nodes[2].name.should eql "Node3"
  end

  its 'parent and children relation' do
    node = Contentr::Node.where(name: "Node21").first
    node.should_not be_nil

    # children
    node.children.should_not be_empty
    node.children[0].name.should eql "Node211"
    node.children[1].name.should eql "Node212"

    # parent
    node.children[0].parent.name.should eql "Node21"
    node.children[1].parent.name.should eql "Node21"
    node.parent.name.should eql "Node2"
  end

  its "parent ids" do
    node = Contentr::Node.where(name: "Node212").first
    node.should_not be_nil
    [node.parent.parent.id, node.parent.id].should eql node.ancestor_ids
  end

  it "change parent" do
    node211 = Contentr::Node.where(name: "Node211").first
    node21  = Contentr::Node.where(name: "Node21").first
    node2   = Contentr::Node.where(name: "Node2").first
    node3   = Contentr::Node.where(name: "Node3").first

    node21.should eql node211.parent
    node2.should eql node21.parent
    [node2.id, node21.id].should eql node211.ancestor_ids
    '/node2/node21/node211'.should eql node211.url_path

    # move node21 to it's new parent node3
    node21.parent = node3
    node21.save!
    node211.reload

    [node3.id, node21.id].should eql node211.ancestor_ids
    '/node3/node21/node211'.should eql node211.url_path
  end
end
