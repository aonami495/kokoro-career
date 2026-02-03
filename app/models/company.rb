class Company < ApplicationRecord
  belongs_to :user

  # Associations
  has_many :company_accommodations, dependent: :destroy
  has_many :accommodation_tags, through: :company_accommodations
  has_many :jobs, dependent: :destroy
  has_many :applications, through: :jobs
  has_many :internships, dependent: :destroy

  # Validations
  validates :user_id, uniqueness: true
  validates :company_name, presence: true

  # 求職者とのマッチ度を計算
  def match_score(job_seeker)
    MatchingService.calculate_score(self, job_seeker)
  end
end
