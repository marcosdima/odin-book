class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]

  def show
    @user_posts = @user.posts.order(created_at: :desc)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
