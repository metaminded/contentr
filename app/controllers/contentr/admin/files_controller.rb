class Contentr::Admin::FilesController < Contentr::Admin::ApplicationController
  def index
    @files = Contentr::File.all
  end

  def new
    @file = Contentr::File.new
  end

  def create
    @file = Contentr::File.new(file_params)
    if @file.save
      flash[:success] = 'File created.'
      redirect_to contentr_admin_files_path(:root => @root_file)
    else
      render :action => :new
    end
  end

  def edit
    @file = Contentr::File.find(params[:id])
  end

  def update
    @file = Contentr::File.find(params[:id])
    if @file.update_attributes(file_params)
      flash[:success] = 'File updated.'
      redirect_to contentr_admin_files_path(:root => @root_file)
    else
      render :action => :edit
    end
  end

  def destroy
    file = Contentr::File.find(params[:id])
    file.destroy
    redirect_to contentr_admin_files_path(:root => @root_file)
  end

  protected
    def file_params
      params.require(:file).permit(*Contentr::File.permitted_attributes)
    end

end
