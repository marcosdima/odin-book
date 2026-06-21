class Request < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validate :sender_distinct_from_receiver
  validate :one_at_the_time, on: :create
  validate :to_update_accepted_should_be_nil, on: :update
  validate :sender_and_receiver_can_not_be_changed, on: :update

  def current_request_pending?(new_request)
    Request.where(
      sender_id: new_request.sender_id,
      receiver_id: new_request.receiver_id,
      type: new_request.type,
      accepted: nil,
    ).exists?
  end

  private
    def sender_distinct_from_receiver
      errors.add(:sender, "can't be the same as receiver") if sender_id == receiver_id
    end

    def one_at_the_time
      if self.current_request_pending?(self)
        errors.add(:base, "a request between these users already exists")
      end
    end

    def sender_and_receiver_can_not_be_changed
      errors.add(:base, "sender and receiver can't be changed") if will_save_change_to_sender_id? || will_save_change_to_receiver_id?
    end

    def to_update_accepted_should_be_nil
      return unless will_save_change_to_accepted?

      old_value, = accepted_change_to_be_saved

      errors.add(:accepted, "can't be updated") unless old_value.nil?
    end
end
