class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i[ likeable_id likeable_type ] }

  scope :by_user, ->(user) { where(user: user) }
  scope :for_likeable, ->(likeable) { where(likeable: likeable) }
  scope :liked_by, ->(user, likeable) { by_user(user).for_likeable(likeable) }
end
