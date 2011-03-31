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
      semesters = @cache[major][req].map{ |c| current_user.semester_of(c) }

      if semesters.all?{ |s| s.state == 'completed' }
        ' completed'
      else
        ' planned'
      end
    end
  end

  def course_class major, req, course
    @cache[major][req].any?{ |c, s| course.id == c.id } ? ' taken' : ''
  end

  def scheduled_data major, req
    @cache[major][req].map{ |a|
      [a.id, current_user.semester_of(a).id]
    }.to_json
  end

  def satisfied? major, req
    req.satisfied? @cache[major][req]
  end

end
