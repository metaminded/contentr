module Contentr
  class GroupedNavPoint < NavPoint

    def replace_with_real_nav
      if Contentr::GroupedNavPointMapping.responds_to?(:map)
        Contentr::GroupedNavPointMapping.map(self.title)
      end
    end
  end
end
