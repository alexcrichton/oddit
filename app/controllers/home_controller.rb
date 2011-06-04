class HomeController < ApplicationController

  def share
  end

  def index
    if current_user
      @user = current_user
      render :template => 'users/show'
    else
      # TODO: have a nice landing page
      redirect_to new_user_session_path
    end
  end

end
