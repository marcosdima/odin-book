class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show destroy ]
  before_action :set_post, only: %i[ show destroy ]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(
      title: post_params[:title],
      text: post_params[:text],
      author: current_user,
    )

    if @post.save
      flash[:success] = "Post created successfully."
      redirect_to @post
    else
      flash.now[:error] = "Unable to create post."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comments = @post.comments.first(10)
  end

  def destroy
    if @post.author != current_user
      flash[:error] = "You can not delete another user's post"
    elsif @post.destroy
      flash[:success] = "Post deleted successfully."
    else
      flash[:error] = "Unable to delete post."
    end

    redirect_to posts_path
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.expect(post: %i[ title text ])
    end
end
