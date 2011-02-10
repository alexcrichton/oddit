class Course
  include Mongoid::Document

  field :number
  field :name
  field :units, :type => Integer

  validates_presence_of :number, :name, :units
  validates_format_of :number, :with => /^\d{2}-\d{3}$/

  attr_accessible :number, :name, :units

  scope :search, lambda{ |q| any_of({:name => /#{q}/i}, {:number => /^#{q}/i}) }

  def pretty_name
    name + " (#{number})"
  end
end
