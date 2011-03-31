module SemestersHelper

  def scheduleman_tooltip
    "This field allows you to sync this semester's classes with what you have" +
    " scheduled on ScheduleMan. If the URL of your schedule is: " +
    content_tag(:code, 'scheduleman.org/schedules/64f6c8ba6e') +
    " then the ID is " + content_tag(:code, '64f6c8ba6e')
  end

  def semester_style semester
    if semester.color
      "border-color: ##{semester.color}"
    end
  end

  def semester_class semester
    ' completed' if semester.state == 'completed'
  end

end
