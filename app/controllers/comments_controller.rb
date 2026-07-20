class CommentsController < ApplicationController
  def create
    @commentable = Post.find(params[:commentable_id])
    @comment = @commentable.comments.create(comment_params)

    if @comment.save
      flash[:success] = "Comment created successfully."
      redirect_to post_path(@commentable)
    else
      flash[:error] = "Unable to create comment."
      redirect_to post_path(@commentable)
    end
  end

  private
    def comment_params
      params.expect(comment: %i[ commentable_id commentable_type text ])
        .merge(author: current_user)
    end
end
