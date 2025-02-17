class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:user][:username])
    if user&.authenticate(params[:user][:password])
      session = user.sessions.create
      cookies.permanent.signed[:twitter_session_token] = session.token
      render json: { message: "Login successful" }, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  def authenticated
    session = Session.find_by(token: cookies.signed[:twitter_session_token])
    if session
      render json: { authenticated: true }
    else
      render json: { authenticated: false }, status: :unauthorized
    end
  end

  def destroy
    session = Session.find_by(token: cookies.signed[:twitter_session_token])
    if session
      session.destroy
      cookies.delete(:twitter_session_token)
      render json: { message: "Logged out" }, status: :ok
    else
      render json: { error: "Session not found" }, status: :unauthorized
    end
  end
end

