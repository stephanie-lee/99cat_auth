class SessionsController < ApplicationController
  before_action :already_logged_in, only: [ :new ]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
     params[:user][:user_name],
     params[:user][:password]
     )

    if @user.nil?
      render :new
    else
      login_user!
      redirect_to cats_url
    end
  end

  def destroy
    if current_user
      @current_user.reset_session_token!
    end

    session[:session_token] = nil

    redirect_to new_session_url
  end
end
