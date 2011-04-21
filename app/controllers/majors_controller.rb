class MajorsController < ApplicationController

  load_and_authorize_resource

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
    new_major.save!

    current_user.major_ids.delete @major.id
    current_user.major_ids << new_major.id
    current_user.save

    @major.inc(:user_count, -1)
    new_major.inc(:user_count, 1)

    redirect_to [:edit, new_major]
  end

  def search
    @majors = Major.search(params[:term]).
      where(:_id.nin => current_user.major_ids)

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
    @major.user_count = 1
    @major.user = current_user

    if @major.save
      location = edit_major_path(@major)
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

    respond_with :majors
  end

end
