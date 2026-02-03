class Application < ApplicationRecord
  belongs_to :job_seeker
  belongs_to :job
  has_many :messages, dependent: :destroy
  has_one :internship, dependent: :destroy

  # Enums
  enum :status, { pending: 0, accepted: 1, rejected: 2 }

  # Validations
  validates :job_seeker_id, uniqueness: { scope: :job_id, message: "この求人には既に応募済みです" }

  # 実習オファーがあるか
  def has_internship_offer?
    internship.present?
  end
end
