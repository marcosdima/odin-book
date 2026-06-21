require "test_helper"

class RequestTest < ActiveSupport::TestCase
  def setup
    @sender = create_user
    @receiver = create_user(1)
  end

  describe "Creating a request" do
    test "Should Create a valid request" do
      request = Request.new(sender: sender, receiver: receiver)
      assert request.valid?
    end

    test "Should not create a request with the same sender and receiver" do
      request = Request.new(sender: @sender, receiver: @sender)
      assert_not request.valid?
      assert_includes request.errors[:sender], "can't be the same as receiver"
    end

    test "Should not create a request if there's already a pending one between the same users" do
      # FollowRequest is used because Request can not receive type nil.
      FollowRequest.create!(sender: @sender, receiver: @receiver)
      new_request = FollowRequest.new(sender: @sender, receiver: @receiver)

      assert_not new_request.valid?
      assert_includes new_request.errors[:base], "A request between these users already exists"
    end
  end
  describe "Updating a request" do
    def setup
      Request.create!(sender: @sender, receiver: @receiver)
    end

    test "Should let you update a request accepted attribute to true" do
      request.accepted = true
      assert request.valid?
    end

    test "Should not let you update a request accepted attribute to false" do
      request.accepted = false
      assert_not request.valid?
    end
  end
end
