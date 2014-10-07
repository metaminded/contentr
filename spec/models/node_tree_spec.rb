# coding: utf-8

require 'spec_helper'

describe Contentr::Page do

  before(:each) do

    site = create(:site)
    node1 = create(:contentpage, name: 'Node1', slug: 'Node1', parent: site)
    node2 = create(:contentpage, name: 'Node2', slug: 'Node2', parent: site)
    node3 = create(:contentpage, name: 'Node3', slug: 'Node3', parent: site)

    node11 = create(:contentpage, name: 'Node11', slug: 'Node11', parent: node1)
    node12 = create(:contentpage, name: 'Node12', slug: 'Node12', parent: node1)
    node21 = create(:contentpage, name: 'Node21', slug: 'Node21', parent: node2)
    node22 = create(:contentpage, name: 'Node22', slug: 'Node22', parent: node2)
    node31 = create(:contentpage, name: 'Node31', slug: 'Node31', parent: node3)

    node211 = create(:contentpage, name: 'Node211', slug: 'Node211', parent: node21)
    node212 = create(:contentpage, name: 'Node212', slug: 'Node212', parent: node21)
    node221 = create(:contentpage, name: 'Node221', slug: 'Node221', parent: node22)
  end

  it 'root nodes' do
    root_nodes = Contentr::Page.roots()
    expect(root_nodes).to_not be_nil
    expect(root_nodes.count).to be 1
    expect(root_nodes.first.children.first.name).to eql 'Node1'
    expect(root_nodes.first.children[1].name).to eql 'Node2'
    expect(root_nodes.first.children[2].name).to eql 'Node3' 
  end

  it 'parent and children relation' do
    node = Contentr::Page.where(name: "Node21").first
    expect(node).to_not be_nil

    # children
    expect(node.children).to_not be_empty
    expect(node.children.first.name).to eql 'Node211'
    expect(node.children[1].name).to eql 'Node212'

    # parent
    expect(node.children.first.parent.name).to eql 'Node21'
    expect(node.children[1].parent.name).to eql 'Node21'

    expect(node.parent.name).to eql 'Node2'
  end

  it "parent ids" do
    node = Contentr::Page.where(name: "Node212").first
    expect(node).to_not be_nil
    expect([node.parent.parent.parent.id, node.parent.parent.id, node.parent.id]).to eql node.ancestor_ids
  end

  it "change parent" do
    node211 = Contentr::Page.where(name: "Node211").first
    node21  = Contentr::Page.where(name: "Node21").first
    node2   = Contentr::Page.where(name: "Node2").first
    node3   = Contentr::Page.where(name: "Node3").first

    expect(node21).to eql node211.parent
    expect(node2).to eql node21.parent
    expect([node2.parent.id, node2.id, node21.id]).to eql node211.ancestor_ids
    expect('/node2/node21/node211').to eql node211.url_path

    # move node21 to it's new parent node3
    node21.parent = node3
    node21.save!
    node211.reload

    expect([node3.parent.id, node3.id, node21.id]).to eql node211.ancestor_ids
    expect('/node3/node21/node211').to eql node211.url_path
  end
end
