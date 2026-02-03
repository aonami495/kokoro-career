class Internship < ApplicationRecord
  belongs_to :application
  belongs_to :company
  belongs_to :job_seeker
  belongs_to :job
  has_many :daily_reports, dependent: :destroy

  # 作成前に関連を自動設定
  before_validation :set_references_from_application, on: :create

  # Enums
  enum :status, {
    pending: 0,      # オファー送信済み（回答待ち）
    accepted: 1,     # 求職者が承諾（実習確定）
    in_progress: 2,  # 実習中
    completed: 3,    # 実習終了
    hired: 4         # 本採用決定
  }

  # Validations
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  # Scopes
  scope :active, -> { where(status: [:accepted, :in_progress]) }
  scope :upcoming, -> { accepted.where("start_date > ?", Date.current) }

  # 実習期間（日数）
  def duration_days
    return 0 unless start_date && end_date
    (end_date - start_date).to_i + 1
  end

  # 実習期間（週数）
  def duration_weeks
    (duration_days / 7.0).ceil
  end

  private

  def set_references_from_application
    return unless application
    self.job_seeker ||= application.job_seeker
    self.job ||= application.job
    self.company ||= application.job.company
  end

  def end_date_after_start_date
    return unless start_date && end_date
    if end_date < start_date
      errors.add(:end_date, "は開始日より後の日付を指定してください")
    end
  end
end
