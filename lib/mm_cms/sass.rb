# Add SASS template path for the engine

tl = File.expand_path('../../../public/stylesheets/sass', __FILE__)
cl = File.expand_path('../../../public/stylesheets', __FILE__)
Sass::Plugin.add_template_location(tl, cl)

