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

      def seed_database
        load "#{Rails.root}/config/initializers/contentr.rb"
        puts "Creating some seeds"
        Contentr::Engine.load_seed
      end

      def copy_js
        puts "Copying important js file"
        copy_file '../../../../app/assets/javascripts/contentr/admin/area.js', 'app/assets/javascripts/contentr/area.js'
      end

    end
  end
end
