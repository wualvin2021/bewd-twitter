class TweetsController < ApplicationController
  before_action :require_authentication

  def index
    tweets = Tweet.includes(:user).order(created_at: :desc)
    render json: tweets.as_json(only: [:id, :message, :created_at], include: { user: { only: :username } })
  end

  def create
    tweet = current_user.tweets.new(tweet_params)
    if tweet.save
      render json: tweet, status: :created
    else
      render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    tweet = current_user.tweets.find_by(id: params[:id])
    if tweet
      tweet.destroy
      render json: { message: "Tweet deleted" }, status: :ok
    else
      render json: { error: "Tweet not found or not authorized" }, status: :forbidden
    end
  end

  def index_by_user
    user = User.find_by(username: params[:username])
    if user
      tweets = user.tweets.order(created_at: :desc)
      render json: tweets
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end

  def require_authentication
    unless current_user
      render json: { error: "Not authenticated" }, status: :unauthorized
    end
  end

  def current_user
    session = Session.find_by(token: cookies.signed[:twitter_session_token])
    session&.user
  end
end
