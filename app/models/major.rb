class Major
  include Mongoid::Document

  field :name
  field :year, :type => Integer

  validates_presence_of :name, :year

  embeds_many :requirements
  accepts_nested_attributes_for :requirements, :allow_destroy => true

  scope :search, lambda{ |q| where(:name => /#{q}/i) }

  attr_accessible :name, :year, :requirements_attributes

  def pretty_name
    name + " (#{year})"
  end
end
