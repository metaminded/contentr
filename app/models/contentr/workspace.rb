# coding: utf-8

module Contentr
  class Workspace < Node

    # Contraints
    self.should_enforce_root_node = true
    self.accepted_child_nodes = ["Contentr::Page"]

  end
end
