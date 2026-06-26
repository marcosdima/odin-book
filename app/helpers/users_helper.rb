module UsersHelper
  def your_page?(user)
    current_user == user
  end

  def profile_title(user)
    your_page?(user) ? "Your" : "#{user.username}'s"
  end
end
