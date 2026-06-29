if Rails.env.development?
  User.find_or_create_by!(email: "test@gmail.com") do |user|
    user.username = "test"
    user.password = "123123"
  end

  User.find_or_create_by!(email: "test2@gmail.com") do |user|
    user.username = "test2"
    user.password = "123123"
  end
end
