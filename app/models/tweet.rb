class Tweet < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { minimum: 1, maximum: 280 }
  validates :user, presence: true

  before_validation :set_defaults

  private

  def set_defaults
    self.likes_count ||= 0
    self.retweets_count ||= 0
  end
end
