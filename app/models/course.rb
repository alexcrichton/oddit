class Course
  include Mongoid::Document

  field :number
  field :name
  field :units, :type => Integer

  attr_accessible :number, :name, :units
end
