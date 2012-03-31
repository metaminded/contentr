module Contentr
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Installs Contentr default files"

      source_root ::File.expand_path('../templates', __FILE__)

      def copy_default_theme
        directory 'views', 'app/views'
      end

      def copy_initializer
        copy_file 'contentr.rb', 'config/initializers/contentr.rb'
      end
    end
  end
end
