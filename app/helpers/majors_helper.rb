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

  def requirement_class major, req
    if satisfied?(major, req)
      semesters = @cache[major][req].map{ |a| a[1] }
      if semesters.all?{ |s| s.state == 'completed' }
        " completed"
      end
    end
  end

  def requirement_style major, req
    if satisfied?(major, req)
      semester = @cache[major][req].first.last

      style = "border: 2px solid ##{semester.color};"
      style << "background: #{Color.new(semester.color).lighten(0.8)};"
    end
  end

  def scheduled_data major, req
    @cache[major][req].map{ |a| a.map(&:id) }.to_json
  end

  def satisfied? major, req
    @cache[major][req].size == req.required
  end

end