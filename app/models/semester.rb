class Semester
  include Mongoid::Document

  STATES = [
    ['Planned', 'planned'],
    ['In Progress', 'in_progress'],
    ['Completed', 'completed']
  ]

  field :year, :type => Integer
  field :month
  field :position, :type => Integer
  field :state

  embedded_in :user
  has_and_belongs_to_many :courses

  validates_presence_of :year, :month

  attr_accessible :year, :month, :course_ids, :position, :state

  scope :ordered, order_by(:position.asc).where(:position.ne => nil)

  before_create :insert_into_list

  def insert_into_list
    self[:position] = max_number + 1
  end

  def move_to position
    self.update_attributes! :position => nil

    others = user.semesters.ordered.skip position - 1
    others.each{ |p| p.update_attributes! :position => p.position + 1 }

    number = others.first.try(:position) || (max_number + 2)
    self.update_attributes! :position => number - 1
  end

  def max_number
    user.semesters.ordered.last.try(:position) || 0
  end
end
