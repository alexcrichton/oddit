class OmniauthController < Devise::OmniauthCallbacksController

  include Devise::Controllers::Rememberable

  def new
  end

  def destroy
    if current_user
      forget_me current_user
      sign_out current_user
    end

    redirect_to new_session_path
  end

  def google
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
    else
      newb = User.new{ |u| u.apply_omniauth omniauth }
      user = current_user || User.where(:email => newb.email).first || newb

      if user.save
        user.authentications.create!(
          :provider => omniauth['provider'], :uid => omniauth['uid'])
        flash[:notice] = 'Authentication successful.'

        remember_me user
        sign_in_and_redirect user
      else
        flash[:error] = 'Sorry, we could not log you in'
        redirect_to new_session_path
      end
    end
  end

end
