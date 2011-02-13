class SemestersController < ApplicationController
  load_and_authorize_resource :through => :current_user

  respond_to :html

  def new
    respond_with @semester
  end

  def edit
    respond_with @semester do |format|
      format.js
    end
  end

  def create
    @semester.save

    respond_with @semester, :location => root_path
  end

  def update
    @semester.update_attributes params[:semester]

    respond_with @semester, :location => root_path do |format|
      format.js { render 'update_semester' }
    end
  end

  def destroy
    @semester.destroy

    respond_with @semester do |format|
      format.js
    end
  end

  def sync
    @semester.scheduleman_sync!

    flash.now[:notice] = 'Schedule synced!'

    respond_with @semester do |format|
      format.js { render 'update_semester' }
    end
  end

  def add
    @course = Course.find(params[:course_id]) rescue nil
    @semester.courses << @course
    @semester.save

    respond_with @course do |format|
      format.js { render 'update_semester' }
    end
  end

  def remove
    @course = Course.find(params[:course_id]) rescue nil
    @semester.courses.delete @course
    @semester.save

    respond_with @course  do |format|
       format.js { render 'update_semester' }
     end
  end

end
