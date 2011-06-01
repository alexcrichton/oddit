class OmniauthController < Devise::OmniauthCallbacksController

  include Devise::Controllers::Rememberable
  stream

  def new
  end

  def destroy
    if current_user
      forget_me current_user
      sign_out current_user
    end

    redirect_to new_user_session_path
  end

  def open_id
    login_from_omniauth
  end

  def facebook
    login_from_omniauth
  end

  protected

  def login_from_omniauth
    omniauth = request.env['omniauth.auth']

    authentication = Authentication.where(
      :provider => omniauth['provider'],
      :uid      => omniauth['uid']
    ).first

    if authentication
      remember_me authentication.user
      sign_in_and_redirect authentication.user
    elsif current_user
      current_user.authentications.create!(
        :provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = 'Authentication successful.'

      sign_in_and_redirect current_user
    else
      user = User.where(:email => email_from(omniauth)).first || User.new
      user.apply_omniauth(omniauth)

      if user.save
        remember_me user
        sign_in_and_redirect user
      else
        flash[:error] = 'Sorry, we could not log you in'
        redirect_to login_path
      end
    end
  end

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
