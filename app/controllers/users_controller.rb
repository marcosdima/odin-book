class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]
  def show
    @your_page = current_user == @user
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
