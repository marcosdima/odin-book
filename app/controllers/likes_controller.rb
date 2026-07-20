class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = Like.new(like_params)
    if @like.save
      flash[:success] = @like.likeable_type == "Post" ? "You liked #{@like.likeable.title}" : "Liked successfully."
      redirect_back(fallback_location: root_path, status: :see_other)
    else
      flash[:error] = "Unable to like."
      redirect_back(fallback_location: root_path, status: :unprocessable_entity)
    end
  end

  def unlike
    @like = Like.find_by(like_params)

    if @like
      @like.destroy
      redirect_back fallback_location: root_path, status: :see_other
    else
      flash[:error] = "Like not found."
      redirect_back fallback_location: root_path, status: :not_found
    end
  end

  private
    def like_params
      params.expect(like: %i[ likeable_id likeable_type ])
        .merge(user: current_user)
    end
end
