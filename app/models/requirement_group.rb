class RequirementGroup
  include Mongoid::Document

  field :name

  embedded_in :major
  embeds_many :requirements

  accepts_nested_attributes_for :requirements, :allow_destroy => true

  attr_accessible :requirements_attributes, :name, :visible
  attr_accessor :visible

  def display_name
    name or "Group #{major.requirement_groups.index(self) + 1}"
  end

end
