require 'rails_helper'

RSpec.describe Request, type: :model do
  let(:sender) { create_user }
  let(:receiver) { create_user(1) }

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

    it "Should let you update a request accepted attribute to true" do
      request.accepted = true
      expect(request).to be_valid
    end

    it "Should not let you update a request accepted attribute to false" do
      request.accepted = false
      expect(request).to be_valid
    end

    it "Should not let you update a request accepted attribute if it was already set" do
      request.accepted = true
      request.save!

      request.accepted = false
      expect(request).not_to be_valid
      expect(request.errors[:accepted]).to include("can't be updated")
    end

    it "Should not let you update a request sender" do
      new_sender = create_user(2)
      request.sender = new_sender

      expect(request).not_to be_valid
      expect(request.errors[:base]).to include("sender and receiver can't be changed")
    end

    it "Should not let you update a request receiver" do
      new_receiver = create_user(2)
      request.receiver = new_receiver

      expect(request).not_to be_valid
      expect(request.errors[:base]).to include("sender and receiver can't be changed")
    end
  end
end
