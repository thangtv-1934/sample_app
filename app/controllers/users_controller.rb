class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user
    render file: "#{Rails.root}/public/404", layout: false, status: :not_found
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "wellcome"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
