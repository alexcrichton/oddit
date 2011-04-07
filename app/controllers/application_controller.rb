class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  rescue_from CanCan::AccessDenied do |e|
    store_location!
    if request.format =~ /html/
      flash[:error] = 'Please log in.'
    end

    redirect_to login_path
  end

  rescue_from ActionController::RoutingError,
              ActionController::UnknownAction,
              BSON::InvalidObjectId do |exception|

    @exception     = exception

    render :template => 'errors/404',
           :layout   => 'application',
           :status   => 404
  end

  def current_ability
    @current_ability ||= Ability.new current_user
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.where(:_id => session[:user_id]).first
  end

  def store_location!
    session[:return_to] = request.fullpath
  end

end
