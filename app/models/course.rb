class Course
  include Mongoid::Document

  field :number
  field :name
  field :units, :type => Integer

  validates_presence_of :number, :name, :units

  attr_accessible :number, :name, :units

  scope :search, lambda{ |q| where(:name => /#{q}/i) }
end
