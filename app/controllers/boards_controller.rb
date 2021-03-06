class BoardsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @boards = Board.page(params[:page])
    @tags = Tag.joins(:board_tags).distinct
  end
  
  def new
    @board = Board.new
    @tags = Tag.joins(:board_tags).distinct
  end
  
  def create
    @board = current_user.boards.build(board_params)
    tag_list = params[:board][:name].split(nil)
    
    if @board.save
      @board.save_tag(tag_list)
      flash[:success] = "掲示板が作成されました"
      redirect_to boards_url
    else
      render 'new'
    end
  end

  def show
    @board = Board.find(params[:id])
    @comment = BoardComment.new
    @comments = BoardComment.includes(:user).where(board_id: params[:id]).where(reply_id: nil)
    @replies = BoardComment.includes(:user).where(board_id: params[:id]).where.not(reply_id: nil)
    #@board_tags = @board.tags
  end

  def edit
    @board = Board.find(params[:id])
  end
  
  def update
    @board = Board.find(params[:id])
    tag_list = params[:board][:name].split(nil)
    if @board.update(board_params)
      @board.save_tag(tag_list)
      flash[:success] = "更新しました"
      redirect_to @board
    else
      render 'edit'
    end
  end
  
  def destroy
    @board = Board.find(params[:id]).destroy
    flash[:success] = "削除しました"
    redirect_to boards_url
  end
  
  def tag
    @tags = Tag.joins(:board_tags).distinct
    @tag = Tag.find(params[:tag_id])
    @boards = @tag.boards
  end
  
  def search
    @boards = Board.search(params[:search])
    @tags = Tag.joins(:board_tags).distinct
  end
  
    private
    
    def board_params
      params.require(:board).permit(:title, :content)
    end
    
    def correct_user
      @user = Board.find(params[:id]).user
      redirect_to(root_url) unless current_user?(@user)
    end
end
