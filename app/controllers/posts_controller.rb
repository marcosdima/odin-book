class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_post, only: %i[ show ]

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
      render :new
    end
  end

  def show
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.expect(post: %i[ title text ])
    end
end
