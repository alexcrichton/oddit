class UsersController < ApplicationController
  load_and_authorize_resource

  respond_to :html

  def show
    respond_with current_user
  end

  def add_major
    @major = Major.find(params[:major_id]) rescue nil
    current_user.majors << @major
    current_user.save

    respond_with @major do |format|
      format.js
    end
  end

  def remove_major
    @major = Major.find(params[:major_id]) rescue nil
    current_user.majors.delete @major
    current_user.save

    respond_with @major do |format|
       format.js
     end
  end

end
