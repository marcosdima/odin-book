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

  validates :avatar_url,
    format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" },
    allow_blank: true

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

  validate :import_gravatar_profile, on: :create

  private
    def import_gravatar_profile
      return unless email.present?

      client = GravatarClient.new
      profile = client.profile(email)

      if profile.present?
        self.first_name   ||= profile["first_name"].presence
        self.last_name    ||= profile["last_name"].presence
        self.avatar_url   ||= profile["avatar_url"].presence || client.avatar_url(email)
        self.location     ||= profile["location"].presence
        self.bio          ||= profile["description"].presence
        self.timezone     ||= profile["timezone"].presence
      end
    end
end
