require 'rails_helper'

RSpec.describe "FollowRequests", type: :request do
  let(:user) { create_user }
  let(:other_user) { create_user(index: 1) }
  let(:follow_request_params) { {
    request: { receiver_id: other_user.id, type: "FollowRequest" }
  } }

  describe "POST /requests" do
    before do
      sign_in user
    end

    it "creates a follow request" do
      post requests_path, params: follow_request_params

      expect(response).to have_http_status(:see_other)
      expect(flash[:success]).to eq("Request sent.")

      expect(user.requests_sent.count).to eq(1)
      expect(other_user.requests_received.count).to eq(1)
    end

    describe "returns an error if..." do
      it "the request was already sent" do
        post requests_path, params: follow_request_params
        post requests_path, params: follow_request_params

        expect(response).to have_http_status(:see_other)
        expect(flash[:error]).to eq("Unable to send request.")
      end

      it "the request was already accepted" do
        post requests_path, params: follow_request_params
        FollowRequest.first.accept!

        post requests_path, params: follow_request_params

        expect(response).to have_http_status(:see_other)
        expect(flash[:error]).to eq("Unable to send request.")
      end
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

      expect(response).to have_http_status(:see_other)
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

        expect(response).to have_http_status(:see_other)
        expect(flash[:error]).to eq("This request has already been processed.")
      end
    end
  end

  describe "POST /requests/:id/reject" do
    it "rejects a follow request" do
      sign_in other_user

      follow_request = FollowRequest.create!(
        sender: user,
        receiver: other_user
      )

      post reject_request_path(follow_request)

      expect(response).to have_http_status(:see_other)
      expect(flash[:success]).to eq("Request rejected.")
      expect(Follow.exists?(follower: user, following: other_user)).to be false
    end

    describe "returns an error if..." do
      it "the request has already been processed" do
        sign_in other_user

        follow_request = FollowRequest.create!(
          sender: user,
          receiver: other_user
        )

        post reject_request_path(follow_request)
        post reject_request_path(follow_request)

        expect(response).to have_http_status(:see_other)
        expect(flash[:error]).to eq("This request has already been processed.")
      end
    end
  end
end
