class CoursesController < ApplicationController

  respond_to :html

  load_and_authorize_resource

  def search
    @courses = Course.search(params[:term] || params[:q])

    respond_with @courses do |format|
      format.json {
        @courses = @courses.limit(10)
        render :json => @courses.map { |c|
          {:id => c.id.to_s, :name => c.pretty_name, :value => c.pretty_name}
        }
      }
    end
  end

  def index
    @courses = @courses.page(params[:page]).per(30)
    respond_with @courses
  end

  def show
    respond_with @course
  end

  def new
    respond_with @course
  end

  def edit
    respond_with @course
  end

  def create
    @course.save

    respond_with @course, :location => new_course_path
  end

  def update
    @course.update_attributes params[:course]

    respond_with @course
  end

  def destroy
    @course.destroy

    respond_with :courses
  end

end
