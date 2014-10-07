# WARNING: Under heavy development

1.) Getting the app to start correct

  Add gem:

    gem 'contentr'

  Run migration files from contentr:

    rake contentr_engine:install:migrations db:migrate

  Run Installer:

    rails g contentr:install

  Require contentr in javascripts / stylesheets:

    js:
      //= require contentr

    css:
      @import "contentr";

  Require Compass by adding a additional_stylesheet to the Contentr-Setup (THIS IS A BUG!):

    gem:
      gem 'compass'

    css:
      @import 'compass';

2.) Contentr

  Introduction:
    After getting started using contentr works like this:

    DEVELOPMENT:

      Reach the administration area with localhost:3000/contentr/admin and add new sites and pages to get a navigation structure.
      Just play around here.

      If you try creating a new page you will be asked for a layout contentr should use for rendering this page.

      choose a layout file (in fact it should be present!) and contentr generates a link to the page.
      You can visit it like localhost:3000/test

      Now that you got a link to the page, you want to tell the page how it has to look like.
      For doing this you need to edit the chosen layout file, adding area_tags to the file where you want the dynamic content to appear.

  Modelling new Paragraphs:

  1.) add new Paragraphs to models/contentr like this
  (in this step you just tell the paragraph which attributes it holds, design stuff later)

    // app/models/contentr/text_image_paragraph.rb !
    module Contentr
     class TextImageParagraph < Contentr::Paragraph
         include ActionView::Helpers
         # Fields
         field :headline1, :type => 'String'
         field :headline2, :type => 'String'
         field :body, :type => 'Integer'
         field :image, :type => 'File', :uploader => Contentr::FileUploader
         # Validations
       end
     end



  2.) add a template to a paragraph which gets rendered for it
  (here you decide how it has to look like)
