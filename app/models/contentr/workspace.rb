# coding: utf-8

module Contentr
  class Workspace < Node

    # Contraints
    self.accepted_parent_nodes = [:root]
    self.accepted_child_nodes  = ["Contentr::Page"]

  end
end
