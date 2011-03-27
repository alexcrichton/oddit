class UsersController < ApplicationController
  load_and_authorize_resource

  respond_to :html

  def show
    build_cache current_user.majors
    respond_with current_user
  end

  def add_major
    @major = Major.find(params[:major_id]) rescue nil
    current_user.majors << @major
    current_user.save

    respond_with @major do |format|
      format.js { build_cache [@major] if @major }
    end
  end

  def remove_major
    @major = Major.find(params[:major_id]) rescue nil
    current_user.majors.delete @major
    current_user.save

    respond_with @major do |format|
      format.js
    end
  end

  def update_major
    @major = Major.find(params[:major_id]) rescue nil

    respond_with @major do |format|
      format.js { build_cache [@major] }
    end
  end

  protected

  def build_cache majors
    course_to_semester = {}
    courses_orig = current_user.semesters.map{ |s|
      s.courses.tap{ |a| a.each{ |c| course_to_semester[c] = s } }
    }.flatten

    @cache = {}

    majors.each do |major|
      @cache[major] = {}
      courses = courses_orig.dup

      reqs = major.requirement_groups.map{ |g| g.requirements }.flatten

      reqs.each do |requirement|
        @cache[major][requirement] = []
        req_courses = requirement.courses.dup

        requirement.required.times {
          course = (req_courses & courses).first

          if course
            courses.delete course
            req_courses.delete course
            @cache[major][requirement] << [
              course, course_to_semester[course]]
          else
            break
          end
        }
      end

    end

  end

end
