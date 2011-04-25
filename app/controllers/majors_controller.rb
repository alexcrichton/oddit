class MajorsController < ApplicationController

  load_and_authorize_resource :collection => :search

  respond_to :html

  def index
    @majors = @majors.roots.page(params[:page]).per(10)
    @arranged = Major.any_of(@majors.map(&:subtree_conditions).flatten).
      order(:name.asc).arrange
    respond_with @majors
  end

  def clone
    new_major = @major.clone
    new_major.user_id = current_user.id
    new_major.parent = @major
    new_major.user_count = 1
    new_major.save!

    if current_user.major_ids.include? @major.id
      current_user.major_ids.delete @major.id
      @major.inc(:user_count, -1)
    end

    current_user.major_ids << new_major.id
    current_user.save

    redirect_to [:edit, new_major]
  end

  def search
    @majors = Major.search(params[:term] || params[:q])

    respond_with @majors do |format|
      format.html {
        @majors   = @majors.page(params[:page]).per(10)
        @arranged = @majors.arrange
        render :action => 'index'
      }

      format.json {
        @majors = @majors.where(:_id.nin => current_user.major_ids)
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
    location          = nil
    @major.user_count = 1
    @major.user       = current_user

    if @major.save
      location = edit_major_path(@major)
      current_user.major_ids << @major.id
      current_user.save!
      flash[:notice] = 'Major created! You can now edit it some more.'
    end

    respond_with @major, :location => location
  end

  def update
    @major.update_attributes params[:major]

    respond_with @major, :location => [:edit, @major]
  end

  def destroy
    @major.destroy
    flash[:notice] = 'Major removed.'

    respond_with :majors
  end

end
