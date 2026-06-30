class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username,
    presence: true,
    uniqueness: true,
    length: { minimum: 2, maximum: 50 }

  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  # Requests.
  has_many :requests_sent,
    class_name: "Request",
    foreign_key: "sender_id"

  has_many :requests_received,
    class_name: "Request",
    foreign_key: "receiver_id"

  # Follows.
  has_many :active_follows,
    class_name: "Follow",
    foreign_key: :follower_id,
    dependent: :destroy

  has_many :passive_follows,
    class_name: "Follow",
    foreign_key: :following_id,
    dependent: :destroy

  has_many :following,
    through: :active_follows,
    source: :following

  has_many :followers,
    through: :passive_follows,
    source: :follower

  # Posts.
  has_many :posts, foreign_key: :author_id

  # Comments.
  has_many :comments, foreign_key: :author_id

  # Likes.
  has_many :likes
end
