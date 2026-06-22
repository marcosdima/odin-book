class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :requests_sent, class_name: "Request", foreign_key: "sender_id"
  has_many :requests_received, class_name: "Request", foreign_key: "receiver_id"

  validates :username, presence: true, uniqueness: true, length: { minimum: 2, maximum: 50 }
end
