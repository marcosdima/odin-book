module PostHelpers
  def create_post(user, attrs = {})
    Post.create!(
      {
        title: "Test Post",
        text: "This is a test post.",
        author: user
      }.merge(attrs)
    )
  end
end
