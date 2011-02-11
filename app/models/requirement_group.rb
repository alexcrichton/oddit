class RequirementGroup
  include Mongoid::Document

  field :name

  validates_presence_of :name

  embedded_in :major
  embeds_many :requirements

  accepts_nested_attributes_for :requirements, :allow_destroy => true

  attr_accessible :requirements_attributes, :name
end
