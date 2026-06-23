class Request < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validate :sender_distinct_from_receiver
  validate :one_at_the_time, on: :create

  attr_readonly :sender_id, :receiver_id

  class AlreadyProcessedError < StandardError; end

  def there_is_a_pending_request?(new_request)
    Request.where(
      sender_id: new_request.sender_id,
      receiver_id: new_request.receiver_id,
      type: new_request.type,
      accepted: nil,
    ).exists?
  end

  def pending?
    accepted.nil?
  end

  def accept!
    transaction do
      raise AlreadyProcessedError unless pending?
      perform_acceptance
      update!(accepted: true)
    end
  end

  def reject!
    transaction do
      raise AlreadyProcessedError unless pending?
      update!(accepted: false)
    end
  end

  private
    def perform_acceptance
      raise NotImplementedError
    end

    def sender_distinct_from_receiver
      errors.add(:sender, "can't be the same as receiver") if sender_id == receiver_id
    end

    def one_at_the_time
      if self.there_is_a_pending_request?(self)
        errors.add(:base, "a request between these users already exists")
      end
    end
end
