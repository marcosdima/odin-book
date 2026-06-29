module LikesHelper
  def like_params_for(likeable)
    {
      like: {
        likeable_id: likeable.id,
        likeable_type: likeable.class.name
      }
    }
  end

  def already_liked?(likeable)
    Like.liked_by(current_user, likeable).any?
  end
end
