class CompanyAccommodation < ApplicationRecord
  belongs_to :company
  belongs_to :accommodation_tag

  # Validations
  validates :company_id, uniqueness: { scope: :accommodation_tag_id }
end
