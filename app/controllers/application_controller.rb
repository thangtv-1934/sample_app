class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  protect_from_forgery with: :exception

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "users.p_login."
      redirect_to login_url
    end
  end
end
