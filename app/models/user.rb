class User
  include Mongoid::Document

  field :andrew_id
  field :email

  has_and_belongs_to_many :majors
  embeds_many :semesters

  validates_presence_of :andrew_id, :email
  validates_uniqueness_of :andrew_id, :email

  attr_accessible :andrew_id, :email

  after_create :initialize_semesters

  def preload_courses!
    mapping = Hash.new{ |h, k| h[k] = Set.new }
    course_ids = Set.new
    semesters.each{ |s|
      s.course_ids.each{ |id|
        mapping[id] << s
        course_ids << id
      }
      s.courses = []
    }

    majors.each{ |major|
      major.requirement_groups.each{ |group|
        group.requirements.each{ |req|
          req.course_ids.each { |id|
            mapping[id] << req
            course_ids << id
          }
          req.courses = []
        }
      }
    }

    Course.where(:_id.in => course_ids.to_a).each do |course|
      mapping[course.id].each{ |o| o.courses << course }
    end
  end

  def semester_of course
    semesters.detect{ |s| s.course_ids.include?(course.id) }
  end

  protected

  def initialize_semesters
    palette = Semester::PALETTES[rand(Semester::PALETTES.size)]

    8.times{ |i|
      semesters.create!(:name => "Semester #{i + 1}", :status => 'planned',
        :color => palette[i])
    }
  end

end
