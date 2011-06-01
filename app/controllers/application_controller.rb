class ApplicationController < ActionController::Base
  protect_from_forgery
  stream

  helper_method :current_user

  rescue_from CanCan::AccessDenied do |e|
    session['user_return_to'] = request.fullpath if request.get?

    if request.format =~ /html/
      flash[:error] = 'Please log in.'
    end

    redirect_to new_user_session_path
  end

  rescue_from ActionController::RoutingError,
              ActionController::UnknownAction,
              BSON::InvalidObjectId do |exception|

    @exception = exception

    render :template => 'errors/404',
           :layout   => 'application',
           :status   => 404
  end

  def current_ability
    @current_ability ||= Ability.new current_user
  end

  def after_sign_out_path_for scope
    new_user_session_path
  end

end
