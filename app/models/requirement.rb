class Requirement
  include Mongoid::Document

  field :name
  field :required, :type => Integer, :default => 1
  field :use_others_in_group, :type => Boolean, :default => false

  validates_presence_of :name
  validates_size_of :course_ids, :minimum => 1, :unless => :use_others_in_group

  embedded_in :requirement_group
  has_and_belongs_to_many :courses

  attr_accessible :name, :course_ids, :required, :use_others_in_group

  def satisfy! courses, used
    id_pool = course_ids

    if use_others_in_group
      id_pool = requirement_group.requirements.map(&:course_ids).flatten
    end

    (1..required).map {
      course = courses.detect{ |c| !used[c] && id_pool.include?(c.id) }
      used[course] = true
      course
    }.compact
  end

  def satisfied? courses
    courses.size == required
  end

end
