class MajorsController < ApplicationController

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
    location = nil
    location = edit_major_path(@major) if @major.save

    respond_with @major, :location => location
  end

  def update
    @major.update_attributes params[:major]

    respond_with @major, :location => [:edit, @major]
  end

  def destroy
    @major.destroy

    respond_with :majors
  end

end
