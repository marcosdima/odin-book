class CommentsController < ApplicationController
  def create
    @commentable = Post.find(params[:commentable_id])
    @comment = @commentable.comments.create(create_comment_params)

    if @comment.save
      flash[:success] = "Comment created successfully."
      redirect_to post_path(@commentable)
    else
      flash[:error] = "Unable to create comment."
      redirect_to post_path(@commentable)
    end
  end

  def destroy
    comment = Comment.find(params[:id])

    if comment.author != current_user
      flash[:error] = "You can not delete another user's comment"
    elsif comment.destroy
      flash[:success] = "Your comment was deleted successfully"
    else
      flash[:error] = "Unable to delete comment."
    end

    redirect_to post_path(comment.commentable)
  end

  private
    def create_comment_params
      params.expect(comment: %i[ commentable_id commentable_type text ])
        .merge(author: current_user)
    end
end
