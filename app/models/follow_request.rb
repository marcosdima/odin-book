class FollowRequest < Request
  validate :check_existing_follow, on: :create

  scope :pendings, ->(user) { where(receiver: user, accepted: nil) }

  private
    def perform_acceptance
      Follow.create!(
        follower: sender,
        following: receiver
      )
    end

    def check_existing_follow
      if Follow.exists?(follower: sender, following: receiver)
        errors.add(:base, "You are already following this user.")
        throw(:abort)
      end
    end
end
