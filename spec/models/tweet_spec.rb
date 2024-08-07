require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe '.create' do
    it 'must belong to a user' do
      expect {
        Tweet.create!(message: 'test')
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'must have the presence of message' do
      expect {
        user = FactoryBot.create(:user)
        FactoryBot.create(:tweet, message: nil, user: user)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'must have a message with max. 140 characters' do
      expect {
        user = FactoryBot.create(:user)
        FactoryBot.create(:tweet, message: 'c' * 141, user: user)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
