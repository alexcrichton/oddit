class Requirement
  include Mongoid::Document

  field :name
  field :required, :type => Integer, :default => 1
  field :use_others_in_group, :type => Boolean, :default => false
  field :course_ids, :type => Array

  validates_presence_of :name
  validates_size_of :course_ids, :minimum => 1, :unless => :use_others_in_group

  embedded_in :requirement_group

  attr_accessible :name, :course_ids, :required, :use_others_in_group
  attr_accessor :courses

  def course_ids= str
    # Forms submit a comma-separated list of IDs, split it here
    str = str.split(',') if str.is_a?(String)
    super str
  end

  def courses
    # Can mongoid do has_and_belongs_to_many where it doesn't update the other
    # end?
    @courses = nil if course_ids_changed?
    @courses ||= Course.where(:_id.in => course_ids)
  end

  def satisfy! courses, used
    id_pool = course_ids

    if use_others_in_group
      id_pool = requirement_group.requirements.map(&:course_ids).flatten
    end

    (1..required).map {
      course = courses.detect{ |c| !used[c.id] && id_pool.include?(c.id) }
      used[course.id] = true
      course
    }.compact
  end

  def satisfied? courses
    courses.size == required
  end

end
