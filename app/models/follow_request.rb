class FollowRequest < Request
  scope :pendings, ->(user) { where(receiver: user, accepted: nil) }

  private
    def perform_acceptance
      Follow.create!(
        follower: sender,
        following: receiver
      )
    end
end
