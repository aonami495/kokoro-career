class JobSeeker < ApplicationRecord
  belongs_to :user

  # Associations
  has_many :job_seeker_accommodations, dependent: :destroy
  has_many :accommodation_tags, through: :job_seeker_accommodations
  has_many :applications, dependent: :destroy
  has_many :applied_jobs, through: :applications, source: :job
  has_many :internships, dependent: :destroy

  # Enums
  enum :disability_type, { mental: 0, physical: 1, intellectual: 2, developmental: 3 }

  # Validations
  validates :user_id, uniqueness: true

  # 必須配慮のみ取得
  def required_accommodation_tags
    accommodation_tags.merge(JobSeekerAccommodation.required)
  end

  # 希望配慮のみ取得
  def preferred_accommodation_tags
    accommodation_tags.merge(JobSeekerAccommodation.preferred)
  end
end
