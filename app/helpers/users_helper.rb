module UsersHelper
  def your_page?
    current_user == @user
  end

  def profile_title
    your_page? ? "Your" : "#{@user.username}'s"
  end

  def already_following?
    current_user.following.include?(@user)
  end

  def follow_pending?
    current_user.requests_sent.where(receiver: @user, type: "FollowRequest", accepted: nil).exists?
  end
end
