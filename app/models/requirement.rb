class Requirement
  include Mongoid::Document

  AMT_COURSES = 'courses'
  AMT_UNITS   = 'units'

  field :name
  field :required, :type => Integer, :default => 1
  field :kind, :default => AMT_COURSES
  field :use_others_in_group, :type => Boolean, :default => false
  field :course_ids, :type => Array, :default => []

  embedded_in :requirement_group

  validates_numericality_of :required

  attr_accessible :name, :course_ids, :required, :use_others_in_group, :kind
  attr_accessor :courses

  def display_name
    name or "Requirement"
  end

  def course_ids= str
    # Forms submit a comma-separated list of IDs, split it here
    str = str.split(',') if str.is_a?(String)
    super str
  end

  def courses
    # Can mongoid do has_and_belongs_to_many where it doesn't update the other
    # end?
    @courses ||= Course.where(:_id.in => course_ids)
  end

  def satisfy! courses, used
    if use_others_in_group
      number_pool = requirement_group.requirements.map(&:courses).
                                      flatten.map(&:number)
    else
      number_pool = self.courses.map(&:number)
    end

    left = required
    used_courses = []
    while left > 0
      course = courses.detect{ |c|
        !used[c.id] && number_pool.include?(c.number)
      }
      if course
        used_courses << course
        left -= kind == AMT_COURSES ? 1 : course.units
        used[course.id] = true
      else
        break
      end
    end
    used_courses
  end

  def amt_satisfied courses
    if kind == AMT_COURSES
      courses.size
    else
      courses.sum(&:units)
    end
  end

  def satisfied? courses
    amt_satisfied(courses) >= required
  end

end
