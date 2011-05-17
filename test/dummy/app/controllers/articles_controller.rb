class ArticlesController < ApplicationController

  contentr

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
    if @article.save
      flash[:success] = "Article saved"
      redirect_to :action => :index
    else
      flash[:error] = "Save failed"
      render :action => :new
    end
  end

end
