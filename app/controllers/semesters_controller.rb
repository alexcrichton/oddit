class SemestersController < ApplicationController
  load_and_authorize_resource :through => :current_user
  before_filter :find_course, :only => [:add, :remove, :transfer]

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
    @semester.course_ids << @course.id
    @semester.save

    respond_with @course do |format|
      format.js { render 'update_semester' }
    end
  end

  def remove
    @semester.course_ids.delete @course.id
    @semester.save

    respond_with @course  do |format|
       format.js { render 'update_semester' }
     end
  end

  def transfer
    @to = current_user.semesters.find params[:to]
    @semester.course_ids.delete @course.id
    @to.course_ids << @course.id
    @semester.save
    @to.save

    respond_with @course do |format|
      format.js { render 'update_semester' }
    end
  end

  protected

  def find_course
    if params[:course_id].blank?
      courses = Course.search(params[:course_name])
      @course = courses.first if courses.size == 1
    end

    @course ||= Course.find(params[:course_id])
  end

end
