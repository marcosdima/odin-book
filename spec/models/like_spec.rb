require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create_user }
  let(:user2) { create_user(index: 1) }
  let(:post) { create_post(user) }

  describe 'creation' do
    it 'an user can like a likeable' do
      like = Like.new(likeable: post, user: user)
      expect(like.save).to be_truthy
      expect(post.likes).to include(like)
      expect(user.likes).to include(like)
    end

    it 'multiple users can like the same likeable' do
      like1 = Like.new(likeable: post, user: user)
      like2 = Like.new(likeable: post, user: user2)
      expect(like1.save).to be_truthy
      expect(like2.save).to be_truthy
      expect(post.likes).to include(like1, like2)
    end

    describe 'fails...' do
      it 'without an associated likeable' do
        like = Like.new(likeable: nil, user: user)
        expect(like.save).to be_falsey
      end

      it 'without an user' do
        like = Like.new(likeable: post, user: nil)
        expect(like.save).to be_falsey
      end

      it 'with a duplicate like for the same likeable and user' do
        Like.create!(likeable: post, user: user)
        like = Like.new(likeable: post, user: user)
        expect(like.save).to be_falsey
      end
    end
  end

  describe 'polimorphic association' do
    it 'can be associated with a comment' do
      comment = create_comment(user, post)
      expect(comment.save).to be_truthy

      like = Like.new(likeable: comment, user: user)
      expect(like.save).to be_truthy
      expect(comment.likes).to include(like)
      expect(user.likes).to include(like)
    end

    it 'can be associated with a post' do
      like = Like.new(likeable: post, user: user)
      expect(like.save).to be_truthy
      expect(post.likes).to include(like)
      expect(user.likes).to include(like)
    end
  end
end
