class MmCms::Site

  def self.themes_path
    File.join(Rails.root, 'public', 'mm_cms', 'themes')
  end

  def self.theme_name
    'defraction'
  end

  def self.theme_path
    File.join(self.themes_path, theme_name)
  end

  def self.default_page_path
    'home'
  end

end
