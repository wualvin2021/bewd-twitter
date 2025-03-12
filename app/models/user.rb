class User < ApplicationRecord
  has_secure_password
  has_many :tweets, dependent: :destroy
  has_many :sessions, dependent: :destroy

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 64 }
  validates :password, length: { minimum: 8, maximum: 64 }, allow_nil: true
  validates :email, presence: true, uniqueness: true, length: { minimum: 5, maximum: 500 },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }
end



