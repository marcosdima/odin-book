require 'rails_helper'

RSpec.describe FollowRequest, type: :model do
  let(:user) { create_user }
  let(:other_user) { create_user(index: 1) }

  it "a user can send a follow request" do
    FollowRequest.create(sender: user, receiver: other_user)

    expect(user.requests_sent.count).to eq(1)
    expect(other_user.requests_received.count).to eq(1)
  end

  it "a user cannot send a follow request to the same user twice" do
    FollowRequest.create!(sender: user, receiver: other_user)
    duplicate_request = FollowRequest.new(sender: user, receiver: other_user)

    expect(duplicate_request.valid?).to be false
    expect(duplicate_request.errors[:sender_id]).to include("has already been taken")
  end
end
