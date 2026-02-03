class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enums
  enum :user_type, { job_seeker: 0, company: 1, support_agency: 2, admin: 9 }

  # Associations
  has_one :job_seeker, dependent: :destroy
  has_one :company, dependent: :destroy
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "recipient_id", dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :user_type, presence: true
end
