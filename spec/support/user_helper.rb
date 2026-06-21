module UserHelpers
  def create_user(index = 0, attrs = {})
    User.create!(
        {
          email: "test#{index}@example.com",
          password: "password123"
        }.merge(attrs)
    )
  end
end
