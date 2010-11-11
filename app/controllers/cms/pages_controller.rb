class Cms::PagesController < Cms::ApplicationController

  def show
    render :text => "Hello World. Your Path #{params[:path]}"
  end

end