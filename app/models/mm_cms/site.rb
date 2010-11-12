class MmCms::Site

  def self.themes_path
    File.join(Rails.root, 'themes')
  end

  def self.theme_name
    'default'
  end

  def self.theme_path
    File.join(self.themes_path, theme_name)
  end

end
