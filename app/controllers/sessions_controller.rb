class SessionsController < ApplicationController

  def new
  end

  def failure
    flash[:error] = 'Failed authenticating!'
    redirect_to login_path
  end

  def create
    omniauth = request.env['omniauth.auth']

    authentication = Authentication.where(:provider => omniauth['provider'],
      :uid => omniauth['uid']).first

    if authentication
      flash[:notice]    = 'Signed in successfully.'
      session[:user_id] = authentication.user_id

      redirect_back_or_default root_path
    elsif current_user
      current_user.authentications.create!(
        :provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = 'Authentication successful.'

      redirect_to root_url
    else
      user = User.where(:email => email_from(omniauth)).first || User.new
      user.apply_omniauth(omniauth)

      if user.save
        flash[:notice] = 'Signed in successfully.'
        session[:user_id] = user.id
        redirect_back_or_default root_path
      else
        flash[:error] = 'Sorry, we could not log you in'
        redirect_to login_url
      end
    end
  end

  def destroy
    session[:user_id]   = nil
    session[:return_to] = nil

    redirect_to login_path
  end

  protected

  def redirect_back_or_default path
    redirect_to session[:return_to] ? session[:return_to] : path
    session[:return_to] = nil
  end

  def email_from omniauth
    email = omniauth['user_info']['email']
    if email.blank? && omniauth['extra'] && omniauth['extra']['user_hash']
      email = omniauth['extra']['user_hash']['email']
    end
    email
  end

end
