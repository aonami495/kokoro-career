class DailyReport < ApplicationRecord
  belongs_to :internship
  belongs_to :user

  # Validations
  validates :content, presence: true
  validates :report_date, presence: true
  validates :report_date, uniqueness: { scope: [:internship_id, :user_id], message: "この日の日報は既に投稿済みです" }

  # Scopes
  scope :by_date, -> { order(report_date: :desc, created_at: :desc) }
  scope :on_date, ->(date) { where(report_date: date) }

  # 投稿者の種類
  def author_type
    if user.job_seeker?
      :job_seeker
    elsif user.company?
      :company
    else
      :other
    end
  end
end
