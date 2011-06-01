class UsersController < ApplicationController

  load_resource :except => [:show]
  before_filter :find_user, :only => [:show]
  authorize_resource

  respond_to :html

  def show
    respond_with @user
  end

  def home
    @user = current_user

    respond_with @user do |format|
      format.html { render 'show' }
    end
  end

  def add_major
    @user = current_user
    @major = Major.find(params[:major_id])
    current_user.major_ids << @major.id
    current_user.save
    @major.inc(:user_count, 1)

    respond_with @major do |format|
      format.html { redirect_to root_path }
      format.js { build_cache [@major] if @major }
    end
  end

  def remove_major
    @user = current_user
    @major = Major.find(params[:major_id])
    current_user.major_ids.delete @major.id
    current_user.save
    @major.inc(:user_count, -1)

    respond_with @major do |format|
      format.js
    end
  end

  def update_major
    @user = current_user
    @major = Major.find(params[:major_id])

    respond_with @major do |format|
      format.js { build_cache [@major] }
    end
  end

  protected

  def find_user
    @user = User.where(:andrew_id => params[:id]).first ||
      User.find(params[:id])
  end

end
