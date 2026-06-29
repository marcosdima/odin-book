require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create_user }
  let(:other_user) { create_user(1) }
  let(:user_post) { create_post(user) }
  let(:comment) { create_comment(user, user_post) }

  before do
    sign_in user
  end

  describe "POST /likes" do
    it "like a comment" do
      post likes_path, params: { like: { likeable_id: comment.id, likeable_type: "Comment" } }
      expect(response).to have_http_status(:see_other)
    end

    it "like a post" do
      post likes_path, params: { like: { likeable_id: user_post.id, likeable_type: "Post" } }
      expect(response).to have_http_status(:see_other)
    end

    it "returns an error if the like already exists" do
      post likes_path, params: { like: { likeable_id: comment.id, likeable_type: "Comment" } }
      post likes_path, params: { like: { likeable_id: comment.id, likeable_type: "Comment" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /likes/unlike" do
    it "unlike a comment" do
      post likes_path, params: { like: { likeable_id: comment.id, likeable_type: "Comment" } }
      delete unlike_likes_path, params: { like: { likeable_id: comment.id, likeable_type: "Comment" } }
      expect(response).to have_http_status(:see_other)
    end

    it "unlike a post" do
      post likes_path, params: { like: { likeable_id: user_post.id, likeable_type: "Post" } }
      delete unlike_likes_path, params: { like: { likeable_id: user_post.id, likeable_type: "Post" } }
      expect(response).to have_http_status(:see_other)
    end

    it "returns an error if the like does not exist" do
      delete unlike_likes_path, params: { like: { likeable_id: comment.id, likeable_type: "Comment" } }
      expect(response).to have_http_status(404)
    end
  end
end
