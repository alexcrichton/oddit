module MajorsHelper

  def completed_requirements_count obj
    groups = obj.is_a?(Major) ? obj.requirement_groups : [obj]

    groups.map { |group|
      group.requirements.select{ |r|
        @cache[r.requirement_group.major][r].size > 0
      }.count
    }.sum
  end

  def requirements_count obj
    groups = obj.is_a?(Major) ? obj.requirement_groups : [obj]

    groups.map { |group| group.requirements.size }.sum
  end

end
