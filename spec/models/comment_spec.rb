require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create_user }
  let(:post) { create_post(user) }

  describe 'Comment creation' do
    it 'creates a comment successfully' do
      comment = Comment.new(text: "This is a test comment.", commentable: post, author: user)
      expect(comment.save).to be_truthy
      expect(post.comments).to include(comment)
      expect(user.comments).to include(comment)
    end

    describe 'fails to create a comment...' do
      it 'without text' do
        comment = Comment.new(text: nil, commentable: post, author: user)
        expect(comment.save).to be_falsey
      end

      it 'without an associated commentable' do
        comment = Comment.new(text: "This is a test comment.", commentable: nil, author: user)
        expect(comment.save).to be_falsey
      end

      it 'without an author' do
        comment = Comment.new(text: "This is a test comment.", commentable: post, author: nil)
        expect(comment.save).to be_falsey
      end

      it 'with text longer than 500 characters' do
        long_text = "a" * 501
        comment = Comment.new(text: long_text, commentable: post, author: user)
        expect(comment.save).to be_falsey
      end

      it 'with text shorter than 1 character' do
        short_text = ""
        comment = Comment.new(text: short_text, commentable: post, author: user)
        expect(comment.save).to be_falsey
      end
    end
  end
end
