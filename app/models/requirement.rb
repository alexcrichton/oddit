class Requirement
  include Mongoid::Document

  field :name
  field :required, :type => Integer, :default => 1
  field :use_others_in_group, :type => Boolean, :default => false
  field :course_ids, :type => Array, :default => []
  field :pattern

  embedded_in :requirement_group

  validates_numericality_of :required

  attr_accessible :name, :course_ids, :required, :use_others_in_group
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
    id_pool = course_ids

    if use_others_in_group
      id_pool = requirement_group.requirements.map(&:course_ids).flatten
    end

    id_pool.map!(&:to_s)
    regex = pattern? ? Regexp.compile(pattern) : nil

    (1..required).map {
      course = courses.detect{ |c|
        explicit = !used[c.id] && id_pool.include?(c.id.to_s)

        if regex
          explicit = explicit || c.name.match(regex)
        end

        explicit
      }
      used[course.id] = true if course.present?
      course
    }.compact
  end

  def satisfied? courses
    courses.size == required
  end

end
