class UsersController < ApplicationController
  load_and_authorize_resource

  respond_to :html

  def show
    build_cache current_user.majors
    respond_with current_user
  end

  def add_major
    @major = Major.find(params[:major_id])
    current_user.majors << @major
    current_user.save

    respond_with @major do |format|
      format.js { build_cache [@major] if @major }
    end
  end

  def remove_major
    @major = Major.find(params[:major_id])
    current_user.majors.delete @major
    current_user.save

    respond_with @major do |format|
      format.js
    end
  end

  def update_major
    @major = Major.find(params[:major_id])

    respond_with @major do |format|
      format.js { build_cache [@major] }
    end
  end

  protected

  def build_cache majors
    current_user.preload_courses!
    @cache = {}
    majors.each{ |m| @cache[m] = m.satisfy_requirements(current_user) }
  end

end
