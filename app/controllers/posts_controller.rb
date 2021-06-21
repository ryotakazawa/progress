class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :refresh_redirect, only: [:index]
  before_action :correct_user, only: [:destroy]
  
  def index
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿しました"
      redirect_to root_url
    else
      @feed_items = current_user.feed.page(params[:page])
      render 'static_pages/home'
    end
  end
  
  def destroy
    @post.destroy
    flash[:success] = "削除しました"
    redirect_to request.referrer || root_url
  end
  
  private
  
    def post_params
      params.require(:post).permit(:content)
    end
    
    def refresh_redirect
      redirect_to root_url
    end
    
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end