module PostsHelper
  def is_author?
    current_user == @post.author
  end
end
