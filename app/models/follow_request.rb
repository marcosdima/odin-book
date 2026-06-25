class FollowRequest < Request
  private
    def perform_acceptance
      Follow.create!(
        follower: sender,
        following: receiver
      )
    end
end
