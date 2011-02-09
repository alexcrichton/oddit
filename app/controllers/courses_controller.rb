class CoursesController < ApplicationController
  
  respond_to :html
  
  def search
    @courses = Course.search(params[:term])
    
    respond_with @courses do |format|
      format.json {
        render :json => @courses.map { |c|
          {:id => c.id, :value => c.name}
        }
      }
    end
  end
  
end
