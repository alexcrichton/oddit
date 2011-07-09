task :cron => [:environment] do
  if Time.now.wday == 3
    Rake::Task['cmu:import_courses'].invoke

    require 'major' # needed in production...
    Major.clean_useless_majors!
  end
end
