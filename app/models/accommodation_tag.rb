class AccommodationTag < ApplicationRecord
  CATEGORIES = %w[environment communication schedule support].freeze

  # Associations
  has_many :job_seeker_accommodations, dependent: :destroy
  has_many :company_accommodations, dependent: :destroy
  has_many :job_seekers, through: :job_seeker_accommodations
  has_many :companies, through: :company_accommodations

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  # Scopes by category
  scope :environment, -> { where(category: "environment") }
  scope :communication, -> { where(category: "communication") }
  scope :schedule, -> { where(category: "schedule") }
  scope :support, -> { where(category: "support") }

  # Sort by display_order
  scope :ordered, -> { order(:display_order, :id) }

  # カテゴリの日本語ラベル
  CATEGORY_LABELS = {
    "environment" => "作業環境",
    "communication" => "コミュニケーション",
    "schedule" => "勤務時間",
    "support" => "サポート体制"
  }.freeze

  def self.category_label(category)
    CATEGORY_LABELS[category] || category
  end

  def category_label
    self.class.category_label(category)
  end
end
