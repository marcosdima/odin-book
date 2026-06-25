class PagesController < ApplicationController
  def home
    @recent_posts = Post.order(created_at: :desc).limit(5)
  end

  def about
  end
end
