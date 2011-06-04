class RequirementGroup
  include Mongoid::Document

  field :name

  embedded_in :major
  embeds_many :requirements

  attr_accessible :name

  def display_name
    name or "Group #{major.requirement_groups.index(self) + 1}"
  end

  def visible
    requirements.size < 3
  end

end
