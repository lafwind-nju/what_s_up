class PostsController < ApplicationController

  before_action :find_post, only: [:show, :edit, :update, :destroy, :like, :share, :is_share?]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :judge_user, only: [:edit, :update, :destroy, :share]


  def index
    @posts = Post.where(share: true)
  end

  def show
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post, notice: "Create successfully~~"
    else
      flash.now[:alert] = "Something wrong here!!"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Update successfully~~"
    else
      flash.now[:alert] = "Something wrong here!!"
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  def like
    @post.liked_by current_user
    redirect_to :back
  end

  def share
    is_share? ? @post.update(share: false) : @post.update(share: true)
    redirect_to :back
  end

  private

    def find_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :url, :share, :description)
    end

    def judge_user
      find_post
      if @post.user_id != current_user.id
        redirect_to root_path
      end
    end

    def is_share?
      @post.share
    end
end
