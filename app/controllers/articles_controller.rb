class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @articles = Article.page(params[:page])
    @tags = Tag.joins(:article_tags).distinct
  end

  def new
    @article = Article.new
    @tags = Tag.joins(:article_tags).distinct
  end
  
  def create
    @article = current_user.articles.build(article_params)
    tag_list = params[:article][:name].split(nil)
    
    
    if @article.save
      @article.save_tag(tag_list)
      flash[:success] = "記事を投稿しました"
      redirect_to articles_url
    else
      @tags = Tag.all
      render 'new'
    end
  end
  
  def show
    @article = Article.find(params[:id])
    if logged_in?
      @comment = current_user.article_comments.build
      @comment.article_id = params[:id]
    end
    @article_tags = @article.tags
  end

  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    tag_list = params[:article][:name].split(nil)
    if @article.update(article_params)
      @article.save_tag(tag_list)
      flash[:success] = "記事が更新されました"
      redirect_to @article
    else
      render 'edit'
    end
  end
  
  def destroy
    @article = Article.find(params[:id]).destroy
    flash[:success] = "記事を削除しました"
    redirect_to articles_url
  end
  
  def tag
    @tags = Tag.joins(:article_tags).distinct
    @tag = Tag.find(params[:tag_id])
    @articles = @tag.articles.all
  end
  
  def search
    @articles = Article.search(params[:search])
    @tags = Tag.joins(:article_tags).distinct
  end
  
    private
    
    def article_params
      params.require(:article).permit(:title, :content)
    end
    
    def correct_user
      @user = Article.find(params[:id]).user
      redirect_to(root_url) unless current_user?(@user)
    end
end
