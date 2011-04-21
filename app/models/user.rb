class User
  include Mongoid::Document

  devise :rememberable, :omniauthable

  field :andrew_id
  field :email
  field :name
  field :major_ids, :type => Array, :default => []

  has_many :authentications, :dependent => :destroy
  embeds_many :semesters

  validates_uniqueness_of :email

  attr_accessible :andrew_id, :email

  after_create :initialize_semesters
  before_destroy :decrement_major_counts

  def majors
    @majors ||= Major.where(:_id.in => major_ids).to_a # Trigger the query
  end

  def display_name
    name.blank? ? email : name
  end

  def apply_omniauth(omniauth)
    if email.blank?
      self.email ||= omniauth['user_info']['email']

      if omniauth['extra'] && omniauth['extra']['user_hash']
        self.email ||= omniauth['extra']['user_hash']['email']
      end
    end

    if name.blank?
      self.name ||= omniauth['user_info']['name']
    end

    authentications.build(
      :provider => omniauth['provider'],
      :uid      => omniauth['uid']
    )
  end

  def preload_courses!
    mapping    = Hash.new{ |h, k| h[k] = Set.new }
    course_ids = Set.new
    semesters.each{ |s|
      s.course_ids.each{ |id|
        mapping[id.to_s] << s
        course_ids << id
      }
      s.courses = []
    }

    majors.each{ |major|
      major.requirements.each{ |req|
        req.course_ids.each { |id|
          mapping[id.to_s] << req
          course_ids << id
        }
        req.courses = []
      }
    }

    Course.where(:_id.in => course_ids.to_a).each do |course|
      mapping[course.id.to_s].each{ |o| o.courses << course }
    end
  end

  def semester_of course
    semesters.detect{ |s| s.course_ids.include?(course.id) }
  end

  protected

  def decrement_major_counts
    majors.each{ |m| m.inc(:user_count, -1) }
  end

  def initialize_semesters
    8.times{ |i|
      semesters.create!(:name => "Semester #{i + 1}", :status => 'planned')
    }
  end

end
