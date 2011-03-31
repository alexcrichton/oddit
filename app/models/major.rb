class Major
  include Mongoid::Document

  field :name
  field :year, :type => Integer

  validates_presence_of :name, :year

  embeds_many :requirement_groups
  accepts_nested_attributes_for :requirement_groups, :allow_destroy => true

  scope :search, lambda{ |q| where(:name => /#{q}/i) }

  attr_accessible :name, :year, :requirement_groups_attributes

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

end
