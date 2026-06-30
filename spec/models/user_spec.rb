require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "with valid attributes" do
      user = User.new(user_params)
      expect(user).to be_valid
    end

    describe "should fail validation" do
      it "when username is missing" do
        user = User.new(user_params(attrs: { username: nil }))
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("can't be blank")
      end

      it "when username is too short" do
        user = User.new(user_params(attrs: { username: "a" }))
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("is too short (minimum is 2 characters)")
      end

      it "when username is too long" do
        user = User.new(user_params(attrs: { username: "a" * 51 }))
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("is too long (maximum is 50 characters)")
      end

      it "when email is missing" do
        user = User.new(user_params(attrs: { email: "" }))
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it "when email is invalid" do
        user = User.new(user_params(attrs: { email: "invalid_email" }))
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("must be a valid email address")
      end
    end
  end
end
