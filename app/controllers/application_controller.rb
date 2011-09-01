class ApplicationController < ActionController::Base
  protect_from_forgery

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

  layout Proc.new{ |c|
    c.request.format.to_s =~ /html/ && c.request.xhr? ? false : :application
  }

  protected

  # We stream all actions, and you can't set cookies once the rendering process
  # has started (i.e. the view can't set any cookies). This is a problem because
  # all forms generate the session csrf_token when they're rendered. If the
  # csrf_token wasn't already set in the session, then it's not set at all
  # because we're streaming. Hence, the csrf_token for the user's session isn't
  # set when they enter a form. When the comparison against the csrf_token in
  # the session and the supplied csrf_token from a request are compared, a new
  # token for the session is created and it's different.
  #
  # For this reason, we just make sure that the csrf_token is always set on all
  # requests. This doesn't regenerate the csrf token, it just makes sure that
  # it's always present (so if one isn't set and we're rendering a form then
  # everything works out OK)
  after_filter :set_csrf_token
  def set_csrf_token
    form_authenticity_token()
  end

  def current_ability
    @current_ability ||= Ability.new current_user
  end

  def after_sign_out_path_for scope
    new_user_session_path
  end

end
