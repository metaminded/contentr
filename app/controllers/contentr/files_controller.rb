class Contentr::FilesController < Contentr::ApplicationController

  # The default action to render a view
  def show()
    file = Contentr::File.where(slug: params[:slug]).first
    if file
      send_file file.actual_file, disposition: 'inline'
    else
      render text: 'Not Found', status: '404'
    end
  end

end
