module CommentHelpers
  def create_comment(user, commentable, attrs = {})
    Comment.create!(
      {
        text: "This is a test comment.",
        commentable: commentable,
        author: user
      }.merge(attrs)
    )
  end
end
