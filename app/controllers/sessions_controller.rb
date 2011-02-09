class SessionsController < ApplicationController

  def create
    authorize! :login, User

    session[:user_id] = current_user.id

    redirect_to session[:return_to] || root_path
    session[:return_to] = nil
  end

  def destroy
    session[:user_id] = nil
    session[:return_to] = nil

    redirect_to root_path
  end

end
