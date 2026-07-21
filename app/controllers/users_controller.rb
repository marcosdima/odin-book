class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[ upload_avatar ]
  before_action :set_user, only: %i[ show ]

  def show
    @user_posts = @user.posts.order(created_at: :desc)
    @follow_requests = FollowRequest.pendings(@user)
  end

  def upload_avatar
    url = SupabaseStorage.upload(params[:avatar], current_user.id)

    current_user.update!(avatar_url: url)

    redirect_to current_user, notice: "Avatar actualizado."
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
