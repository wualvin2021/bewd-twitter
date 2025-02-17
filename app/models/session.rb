class Session < ApplicationRecord
  belongs_to :user

  validates :token, presence: true, uniqueness: true, length: { minimum: 32, maximum: 32 }
  validates :expires_at, presence: true

  before_validation :generate
end
