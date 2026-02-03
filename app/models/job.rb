class Job < ApplicationRecord
  JOB_TYPE_OPTIONS = ["正社員", "契約社員", "パート・アルバイト", "業務委託", "その他"].freeze

  belongs_to :company
  has_many :applications, dependent: :destroy
  has_many :applicants, through: :applications, source: :job_seeker
  has_many :internships, dependent: :destroy

  # Enums
  enum :status, { draft: 0, published: 1, closed: 2 }

  # Validations
  validates :title, presence: true
  validates :status, presence: true

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :with_internship, -> { where(internship_available: true) }

  # Delegate accommodation_tags to company
  def accommodation_tags
    company.accommodation_tags
  end
end
