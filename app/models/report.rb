class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User"
  belongs_to :target, polymorphic: true

  # Enums
  enum :reason, { spam: 0, offensive: 1, solicitation: 2, other: 9 }
  enum :status, { pending: 0, resolved: 1, ignored: 2 }

  # Validations
  validates :reason, presence: true
  validates :target, presence: true
  validates :reporter, presence: true

  # Scopes
  scope :unresolved, -> { where(status: :pending) }
  scope :recent, -> { order(created_at: :desc) }

  # 理由の日本語ラベル
  REASON_LABELS = {
    "spam" => "スパム・迷惑行為",
    "offensive" => "不快なコンテンツ",
    "solicitation" => "不正な勧誘",
    "other" => "その他"
  }.freeze

  # ステータスの日本語ラベル
  STATUS_LABELS = {
    "pending" => "未対応",
    "resolved" => "対応済み",
    "ignored" => "却下"
  }.freeze

  def reason_label
    REASON_LABELS[reason] || reason
  end

  def status_label
    STATUS_LABELS[status] || status
  end

  def target_name
    case target
    when Job
      "求人: #{target.title}"
    when User
      "ユーザー: #{target.name}"
    else
      "不明"
    end
  end
end
