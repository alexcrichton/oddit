class CoursesController < ApplicationController

  respond_to :html

  load_and_authorize_resource

  def search
    @courses = Course.search(params[:term] || params[:q])

    respond_with @courses do |format|
      format.json {
        @courses = @courses.limit(10)
        @courses = @courses.to_a.uniq(&:number) if params.key?(:q)
        render :json => @courses.map { |c|
          name = c.pretty_name
          name += params.key?(:term) ? " (#{c.units} units)" : ""
          {:id => c.id.to_s, :name => name, :value => name}
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
