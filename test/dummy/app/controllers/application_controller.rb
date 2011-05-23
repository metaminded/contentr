##
# Force the contentr plugin to be reloaded on evrey request in dev mode.
# Looks like a hack but it works.
#
# http://stackoverflow.com/questions/4713066/plugin-reload-with-each-request-rails-3/4873235#4873235
#
require "contentr"

class ApplicationController < ActionController::Base
  protect_from_forgery
end
