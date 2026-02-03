class Message < ApplicationRecord
  belongs_to :application
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  # Validations
  validates :content, presence: true

  # Scopes
  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }

  # Mark as read
  def mark_as_read!
    update!(read_at: Time.current) if read_at.nil?
  end
end
