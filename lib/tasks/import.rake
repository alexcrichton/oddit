namespace :cmu do

  desc 'Import the schedules currently listed at the CMU SOC'
  task :import_courses => :environment do
    Course.import_cmu!
  end

end
