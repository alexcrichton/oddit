class Major
  include Mongoid::Document

  field :name
  field :year, :type => Integer

  validates_presence_of :name, :year

  embeds_many :requirements
  accepts_nested_attributes_for :requirements, :allow_destroy => true

  attr_accessible :name, :year, :requirements_attributes
end
