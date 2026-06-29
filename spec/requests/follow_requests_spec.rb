require 'rails_helper'

RSpec.describe "FollowRequests", type: :request do
  let(:user) { create_user }
  let(:other_user) { create_user(1) }
  let(:follow_request_params) { {
    request: { receiver_id: other_user.id, type: "FollowRequest" }
  } }

  describe "POST /requests" do
    it "creates a follow request" do
      sign_in user

      post requests_path, params: {
        request: {
          receiver_id: other_user.id,
          type: "FollowRequest"
        }
      }

      expect(response).to have_http_status(:created)
      expect(flash[:success]).to eq("Request sent.")

      expect(user.requests_sent.count).to eq(1)
      expect(other_user.requests_received.count).to eq(1)
    end
  end

  describe "POST /requests/:id/accept" do
    it "accepts a follow request" do
      sign_in other_user

      follow_request = FollowRequest.create!(
        sender: user,
        receiver: other_user
      )

      post accept_request_path(follow_request)

      expect(response).to redirect_to(user_path(other_user))
      expect(flash[:success]).to eq("Request accepted.")
      expect(Follow.exists?(follower: user, following: other_user)).to be true
    end

    describe "returns an error if..." do
      it "the request has already been processed" do
        sign_in other_user

        follow_request = FollowRequest.create!(
          sender: user,
          receiver: other_user
        )

        post accept_request_path(follow_request)
        post accept_request_path(follow_request)

        expect(response).to have_http_status(:found)
        expect(flash[:error]).to eq("This request has already been processed.")
      end

      it "a new request is created for the same users" do
        sign_in other_user

        post requests_path, params: follow_request_params
        post requests_path, params: follow_request_params

        expect(response).to have_http_status(:unprocessable_content)
        expect(flash[:error]).to eq("Unable to send request.")
      end
    end
  end
end
