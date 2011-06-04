class Major
  include Mongoid::Document
  include Mongoid::Ancestry

  # This must be before the call to has_ancestry because we want to override
  # what has_ancestry's default action is to do
  before_destroy :move_children_to_parent

  has_ancestry

  field :name
  field :year, :type => Integer
  field :college
  field :cmu_audit_name
  field :major_file
  field :link
  field :user_count, :type => Integer, :default => 0

  belongs_to :user
  embeds_many :requirement_groups

  validates_format_of :link, :with => %r{^https?://}, :allow_blank => true
  validates_numericality_of :year, :allow_blank => true

  scope :search, lambda{ |q| where(:name => /#{q}/i) }
  scope :valid, where(:name.ne => nil)
  scope :invalid, where(:name => nil)

  attr_accessible :name, :year, :college, :major_file, :link, :cmu_audit_name

  def self.update_user_counts!
    Major.all.each { |m|
      # user_count is a protected attribute
      m.user_count = User.where(:major_ids => m.id).count
      m.save!
    }
  end

  def self.clean_useless_majors!
    Major.invalid.where(:created_at.lt => 1.week.ago.utc).destroy_all
  end

  def audit_url
    if college.present? && major_file.present? && cmu_audit_name.present?
      "https://enr-apps.as.cmu.edu/audit/audit?" + {
        :college   => college,
        :call      => 14,
        :year      => year,
        :MajorFile => major_file.gsub('/', ':'),
        :major     => cmu_audit_name
      }.to_query
    end
  end

  def pretty_name
    name + " (#{year})"
  end

  def requirements
    requirement_groups.map(&:requirements).flatten
  end

  def satisfy_requirements user
    courses = user.semesters.map(&:courses).flatten
    used = {}

    {}.tap do |hash|
      requirements.each do |requirement|
        hash[requirement] = requirement.satisfy!(courses, used)
      end
    end
  end

  protected

  def move_children_to_parent
    children.each{ |c| c.parent = parent; c.save! }
  end

end
