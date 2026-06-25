require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:user) { create_user }
  let(:other_user) { create_user(1) }
  it "a user can follow another" do
    Follow.create(follower: user, following: other_user)

    expect(user.following).to include(other_user)
    expect(other_user.followers).to include(user)

    expect(user.active_follows.count).to eq(1)
    expect(other_user.passive_follows.count).to eq(1)
  end

  it "a user can unfollow another" do
    follow = Follow.create(follower: user, following: other_user)
    follow.destroy

    expect(user.following).not_to include(other_user)
    expect(other_user.followers).not_to include(user)

    expect(user.active_follows.count).to eq(0)
    expect(other_user.passive_follows.count).to eq(0)
  end
end
