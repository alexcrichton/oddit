class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |e|
    redirect_to new_user_session_path
  end

  def current_ability
    @current_ability ||= Ability.new current_user
  end
end
