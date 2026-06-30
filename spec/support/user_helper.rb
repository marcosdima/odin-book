module UserHelpers
  def create_user(index: 0, attrs: {})
    User.create!(user_params(index: index, attrs: attrs))
  end

  def user_params(index: 0, attrs: {})
    {
      email: "test#{index}@example.com",
      password: "password123",
      username: "testuser#{index}"
    }.merge(attrs)
  end
end
