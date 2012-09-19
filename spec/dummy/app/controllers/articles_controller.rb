class ArticlesController < ApplicationController

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
      flash[:message] = "Article saved"
      redirect_to :action => :index
    else
      flash[:message] = "Save failed"
      render :action => :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:message] = "Article saved"
      redirect_to :action => :index
    else
      flash[:message] = "Update failed"
      render :action => :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to :action => :index
  end

end
