class UsersController < ApplicationController
  before_action :already_logged_in, only: [ :new ]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save!
      login_user!
      redirect_to cats_url
    else
      redirect_to new_user_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
