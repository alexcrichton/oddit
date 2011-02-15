class Requirement
  include Mongoid::Document

  field :name
  field :required, :type => Integer, :default => 1

  validates_presence_of :name
  validates_size_of :courses, :minimum => 1

  embedded_in :requirement_group
  has_and_belongs_to_many :courses

  attr_accessible :name, :course_ids, :required

end