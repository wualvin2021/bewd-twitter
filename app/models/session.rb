class Session < ApplicationRecord
  belongs_to :user

  before_validation :generate_token

  validates :user_id, presence: true
  validates :token, presence: true, uniqueness: true

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64
  end
end
