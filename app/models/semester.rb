class Semester
  include Mongoid::Document

  STATES = [
    ['Planned', 'planned'],
    ['In Progress', 'in_progress'],
    ['Completed', 'completed']
  ]

  PALETTES = [
    ['cccc00', '996680', '668099', '669966', '7fff66', '667fff', 'e666ff',
      'eb4e00']
  ]

  field :name
  field :state
  field :scheduleman_id
  field :course_ids, :type => Array, :default => []

  embedded_in :user

  validates_presence_of :name
  validates_format_of :scheduleman_id, :with => /^\w+$/, :allow_blank => true

  attr_accessible :name, :course_ids, :state, :scheduleman_id
  attr_accessor :courses

  before_save :store_changes
  after_save :scheduleman_sync!, :if => :need_sync?

  def scheduleman_url
    if scheduleman_id.present?
      'https://scheduleman.org/schedules/' + scheduleman_id
    end
  end

  def units
    courses.map(&:units).sum
  end

  def courses
    # Can mongoid do has_and_belongs_to_many where it doesn't update the other
    # end?
    # @courses = nil if course_ids_changed?
    @courses ||= Course.where(:_id.in => course_ids)
  end

  # Parses the iCal feed from scheduleman for a schedule given that the ID
  # that scheduleman assigned the schedule has already been entered in
  def scheduleman_sync!
    return unless scheduleman_id.present?

    url = 'https://scheduleman.org/schedules/' + scheduleman_id + '.ics'

    begin
      calendar = RiCal.parse_string(open(url).read)[0]
    rescue OpenURI::HTTPError
      return
    end

    self.course_ids = []

    calendar.events.each do |event|
      next unless event.summary =~ /(\d{2}-\d{3})/

      number = $1
      if course = Course.where(:number => number).first
        course_ids << course.id
      end
    end

    self.course_ids = course_ids.uniq
    save!
  end

  protected

  def need_sync?
    @last_changes && @last_changes.key?('scheduleman_id')
  end

  def store_changes
    @last_changes = changes
  end

end
