class SessionsController < ApplicationController
  def create
    user = User.find_by(username: session_params[:username])

    if user&.authenticate(session_params[:password])
      session = user.sessions.create
      cookies.signed[:twitter_session_token] = { value: session.token, httponly: true } # Store token in a signed cookie
      render json: { success: true }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def authenticated
    session = Session.find_by(token: cookies.signed[:twitter_session_token])

    if session&.user
      render json: { authenticated: true, username: session.user.username }
    else
      render json: { authenticated: false }
    end
  end

  def destroy
    session = Session.find_by(token: cookies.signed[:twitter_session_token])

    if session
      session.destroy # Delete session record
      cookies.delete(:twitter_session_token) # Remove cookie
    end

    render json: { success: true }
  end

  private

  def session_params
    params.require(:user).permit(:username, :password)
  end
end



