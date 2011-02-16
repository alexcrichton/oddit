class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  rescue_from CanCan::AccessDenied do |e|
    store_location!
    flash[:error] = 'Denied!'

    redirect_to login_path
  end

  def current_ability
    @current_ability ||= Ability.new current_user
  end

  def current_user
    @current_user ||= User.last
  end

  def store_location!
    session[:return_to] = request.fullpath
  end

end
