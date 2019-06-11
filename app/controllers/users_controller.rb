class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :load_user, except: %i(index new create)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.order(:name).page(params[:page]).per Settings.user.paginate_per_page
  end

  def show
    @microposts = @user.microposts.page(params[:page]).order_by_create_at
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.user_deleted"
      redirect_to users_url
    else
      flash[:danger] = t "error"
    end
  end

  def following
    @title = t "users.following"
    @user  = User.find_by id: params[:id]
    @users = @user.following.page params[:page]
    render "show_follow"
  end

  def followers
    @title = t "users.followers"
    @user  = User.find_by id: params[:id]
    @users = @user.followers.page params[:page]
    render "show_follow"
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user.current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
