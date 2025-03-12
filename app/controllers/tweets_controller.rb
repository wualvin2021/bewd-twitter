class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    tweet = current_user.tweets.create(message: params[:tweet][:message])
    if tweet.persisted?
      render json: { tweet: { username: current_user.username, message: tweet.message } }
    else
      render json: { error: 'Tweet creation failed' }, status: :unprocessable_entity
    end
  end

  def index
    tweets = Tweet.includes(:user).order(created_at: :desc)
    render json: { tweets: tweets.map { |tweet| { id: tweet.id, username: tweet.user.username, message: tweet.message } } }
  end

  def destroy
    if current_user
      tweet = current_user.tweets.find_by(id: params[:id])
      if tweet
        tweet.destroy
        render json: { success: true }
      else
        render json: { error: 'Tweet not found' }, status: :not_found
      end
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  def index_by_user
    user = User.find_by(username: params[:username])
    if user
      tweets = user.tweets.order(created_at: :desc)
      render json: { tweets: tweets.map { |tweet| { id: tweet.id, username: tweet.user.username, message: tweet.message } } }
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def authenticate_user!
    render json: { success: false }, status: :unauthorized unless current_user
  end

  def current_user
    session = Session.find_by(token: cookies.signed[:twitter_session_token])
    session&.user
  end
end

