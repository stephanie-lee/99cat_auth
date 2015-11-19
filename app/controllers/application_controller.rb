require 'BCrypt'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  helper_method :current_user, :cats_current_owner

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login_user!
    session_token = @user.reset_session_token!
    session[:session_token] = session_token
  end

  def already_logged_in
    if current_user
      flash[:error] = "You're already logged in."

    redirect_to cats_url
    end
  end

  def cats_current_owner
    if current_user.nil?
      return redirect_to cats_url
    end

    if current_user.cats.where("id = ?", params[:id]).empty?
      flash[:error] = "Not your cat."
      redirect_to cats_url
    end
  end
end
