task :cron => [:environment] do
  Rake::Task['cmu:import_courses'].invoke

  require 'major' # needed in production...
  Major.clean_useless_majors!
end
