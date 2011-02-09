class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |e|
    store_location!
    flash[:error] = 'Denied!'

    redirect_to login_path
  end

  def current_ability
    @current_ability ||= Ability.new current_user
  end

  def current_user
    User.first
  end

  def store_location!
    session[:return_to] = request.fullpath
  end

end
