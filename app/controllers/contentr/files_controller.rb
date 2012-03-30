class Contentr::FilesController < Contentr::ApplicationController

  # The default action to render a view
  def show()
    file = Contentr::File.where(slug: params[:slug]).first
    send_file file.actual_file
  end

end