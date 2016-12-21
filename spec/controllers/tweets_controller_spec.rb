require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  render_views

  describe 'POST /tweets' do
    it 'renders new tweet object' do
      user = FactoryGirl.create(:user)
      session = user.sessions.create
      @request.cookie_jar.signed['twitter_session_token'] = session.token

      post :create, params: {
        tweet: {
          message: 'Test Message'
        }
      }

      expect(response.body).to eq({
        tweet: {
          username: user.username,
          message: 'Test Message'
        }
      }.to_json)
    end
  end

  describe 'GET /tweets' do
    it 'renders all tweets object' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:tweet, user: user)
      FactoryGirl.create(:tweet, user: user)

      get :index

      expect(response.body).to eq({
        tweets: [
          {
            id: Tweet.order(created_at: :desc)[0].id,
            username: user.username,
            message: 'Test Message'
          }, {
            id: Tweet.order(created_at: :desc)[1].id,
            username: user.username,
            message: 'Test Message'
          }
        ]
      }.to_json)
    end
  end

  describe 'DELETE /tweets/:id' do
    it 'renders success' do
      user = FactoryGirl.create(:user)
      session = user.sessions.create
      @request.cookie_jar.signed['twitter_session_token'] = session.token

      tweet = FactoryGirl.create(:tweet, user: user)

      delete :destroy, params: { id: tweet.id }

      expect(response.body).to eq({ success: true }.to_json)
      expect(user.tweets.count).to eq(0)
    end

    it 'renders fails if not logged in' do
      user = FactoryGirl.create(:user)
      tweet = FactoryGirl.create(:tweet, user: user)

      delete :destroy, params: { id: tweet.id }

      expect(response.body).to eq({ success: false }.to_json)
      expect(user.tweets.count).to eq(1)
    end
  end

  describe 'GET /users/:id/tweets' do
    it 'renders tweets by username' do
      user_1 = FactoryGirl.create(:user, username: 'user_1', email: 'user_1@user.com')
      user_2 = FactoryGirl.create(:user, username: 'user_2', email: 'user_2@user.com')

      tweet_1 = FactoryGirl.create(:tweet, user: user_1)
      tweet_2 = FactoryGirl.create(:tweet, user: user_2)

      get :index_by_user, params: { username: user_1.username }

      expect(response.body).to eq({
        tweets: [
          {
            id: tweet_1.id,
            username: user_1.username,
            message: 'Test Message'
          }
        ]
      }.to_json)
    end
  end

  describe 'GET /tweets/search/:keyword' do
    it 'renders tweets by keyword' do
      user = FactoryGirl.create(:user)
      tweet_1 = FactoryGirl.create(:tweet, user: user, message: 'asd')
      tweet_2 = FactoryGirl.create(:tweet, user: user, message: 'asd asd')
      tweet_3 = FactoryGirl.create(:tweet, user: user, message: '123')

      get :search, params: { keyword: '123' }

      expect(response.body).to eq({
        tweets: [
          {
            id: tweet_3.id,
            username: user.username,
            message: '123'
          }
        ]
      }.to_json)
    end
  end
end
