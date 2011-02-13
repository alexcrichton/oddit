class Semester
  include Mongoid::Document

  STATES = [
    ['Planned', 'planned'],
    ['In Progress', 'in_progress'],
    ['Completed', 'completed']
  ]

  field :name
  field :state
  field :scheduleman_id

  embedded_in :user
  has_and_belongs_to_many :courses

  validates_presence_of :year, :name
  validates_format_of :scheduleman_id, :with => /^\w+$/, :allow_blank => true

  attr_accessible :year, :name, :course_ids, :position, :state,
    :scheduleman_id

  scope :ordered, order_by(:position.asc).where(:position.ne => nil)

  def units
    courses.map(&:units).sum
  end

  # Parses the iCal feed from scheduleman for a schedule given that the ID
  # that scheduleman assigned the schedule has already been entered in
  def scheduleman_sync!
    return unless scheduleman_id.present?

    url = 'https://scheduleman.org/schedules/' + scheduleman_id + '.ics'

    calendar = RiCal.parse_string(open(url).read)[0]

    self.course_ids = []

    calendar.events.each do |event|
      next unless event.summary =~ /(\d{2}-\d{3})/

      number = $1
      if course = Course.where(:number => number).first
        course_ids << course.id
      end
    end

    save!
  end

end
