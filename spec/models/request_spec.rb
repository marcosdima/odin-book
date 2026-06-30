require 'rails_helper'

RSpec.describe Request, type: :model do
  let(:sender) { create_user }
  let(:receiver) { create_user(index: 1) }

  describe "Creating a request" do
    it "Should Create a valid request" do
      request = Request.new(sender: sender, receiver: receiver)
      expect(request).to be_valid
    end

    it "Should not create a request with the same sender and receiver" do
      request = Request.new(sender: sender, receiver: sender)
      expect(request).not_to be_valid
      expect(request.errors[:sender]).to include("can't be the same as receiver")
    end

    it "Should not create a request if there's already a pending one between the same users" do
      # FollowRequest is used because Request can not receive type nil.
      FollowRequest.create!(sender: sender, receiver: receiver)
      new_request = FollowRequest.new(sender: sender, receiver: receiver)

      expect(new_request).not_to be_valid
      expect(new_request.errors[:base]).to include("a request between these users already exists")
    end
  end

  describe "Updating a request" do
    let(:request) { FollowRequest.create!(sender: sender, receiver: receiver) }

    it "... should let you update a request accepted attribute to true" do
      request.accept!
      expect(request).to be_valid
    end

    it "... should let you update a request accepted attribute to false" do
      request.reject!
      expect(request).to be_valid
    end

    it "... should not let you update accepted attribute if it was already set" do
      request.accept!
      expect { request.reject! }.to raise_error(Request::AlreadyProcessedError)
    end
  end

  describe "methods:" do
    let(:request) { Request.new(sender: sender, receiver: receiver) }
    describe "#pending? ->" do
      it "Should return true if the request is pending" do
        expect(request.pending?).to be true
      end

      it "Should return false if the request is accepted" do
        request.accepted = true
        expect(request.pending?).to be false
      end

      it "Should return false if the request is rejected" do
        request.accepted = false
        expect(request.pending?).to be false
      end
    end
  end
end
