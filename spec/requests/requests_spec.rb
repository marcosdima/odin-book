require 'rails_helper'

RSpec.describe "Requests", type: :request do
  let(:user) { create_user }
  let(:other_user) { create_user(index: 1) }
  let(:follow_request_params) { {
    request: { receiver_id: other_user.id, type: "FollowRequest" }
  } }

  before do
    sign_in user
  end

  describe "POST /requests" do
    describe "Should crete a request if... " do
      it "has valid parameters" do
        post requests_path, params: follow_request_params
        expect(response).to have_http_status(:see_other)
        expect(flash[:success]).to eq("Request sent.")
      end
    end

    describe "Error if... " do
      describe "there are invalid parameters: " do
        it "non-existent receiver" do
          post requests_path, params: {
            request: { receiver_id: 999, sender_id: other_user.id, type: "FollowRequest" }
          }
          expect(response).to have_http_status(404)
        end

        it "invalid request type" do
          post requests_path, params: {
            request: { receiver_id: other_user.id, sender_id: other_user.id, type: "InvalidType" }
          }
          expect(response).to have_http_status(400)
        end
      end

      it "there is already a pending request, with the same type, between the same users" do
        post requests_path, params: follow_request_params
        post requests_path, params: follow_request_params
        expect(response).to have_http_status(:see_other)
      end
    end
  end

  describe "POST /requests/:id/accept" do
    it "accepts a request" do
      post requests_path, params: follow_request_params

      request = Request.last
      post accept_request_path(request)
      expect(response).to have_http_status(:see_other)

      request = Request.last
      expect(request.accepted?).to eq(true)
    end

    it "returns an error if the request has already been processed" do
      post requests_path, params: follow_request_params
      request = Request.last
      post accept_request_path(request)
      post accept_request_path(request)
      expect(response).to have_http_status(:see_other)
      expect(flash[:error]).to eq("This request has already been processed.")
    end
  end

  describe "POST /requests/:id/reject" do
    it "rejects a request" do
      post requests_path, params: follow_request_params

      request = Request.last
      post reject_request_path(request)
      expect(response).to have_http_status(:see_other)

      request = Request.last
      expect(request.accepted?).to eq(false)
    end

    it "returns an error if the request has already been processed" do
      post requests_path, params: follow_request_params
      request = Request.last
      post reject_request_path(request)
      post reject_request_path(request)
      expect(response).to have_http_status(:see_other)
      expect(flash[:error]).to eq("This request has already been processed.")
    end
  end
end
