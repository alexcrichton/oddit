class MajorsController < ApplicationController

  before_filter :extract_course_ids, :only => [:create, :update]

  load_and_authorize_resource

  respond_to :html

  def index
    respond_with @majors
  end

  def search
    @majors = Major.search params[:term]

    respond_with @majors do |format|
      format.json {
        render :json => @majors.map{ |m|
          {:id => m.id, :value => m.pretty_name}
        }
      }
    end
  end

  def show
    respond_with @major
  end

  def new
    respond_with @major
  end

  def edit
    respond_with @major
  end

  def create
    @major.save

    respond_with @major
  end

  def update
    @major.update_attributes params[:major]

    respond_with @major, :location => edit_major_path(@major)
  end

  def destroy
    @major.destroy

    respond_with :majors
  end

  protected

  def extract_course_ids
    return unless params[:major] && params[:major][:requirements_attributes]

    params[:major][:requirements_attributes].each do |_, attrs|
      next unless attrs['course_ids']

      attrs['course_ids'] = attrs['course_ids'].values.reject(&:blank?)
    end
  end

end
