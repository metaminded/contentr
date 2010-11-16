module MmCms

  class Site

    def initialize
      # nope
    end

    def themes_path
      File.join(Rails.root, 'public', 'mm_cms', 'themes')
    end

    def theme_name
      'defraction'
    end

    def theme_path
      File.join(self.themes_path, theme_name)
    end

    def default_page_path
      'home'
    end

    def navigation
      MmCms::Page.all
    end

    def to_liquid
      MmCms::SiteLiquidProxy.new(self)
    end
  end

  class SiteLiquidProxy < ::Liquid::Drop

    def initialize(site)
      @site = site
    end

    def theme_name
      @site.theme_name
    end

    def navigation
      @site.navigation
    end
  end

end
