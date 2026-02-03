class JobSeekerAccommodation < ApplicationRecord
  belongs_to :job_seeker
  belongs_to :accommodation_tag

  # Enums
  enum :priority, { required: 0, preferred: 1 }

  # Validations
  validates :job_seeker_id, uniqueness: { scope: :accommodation_tag_id }
end
