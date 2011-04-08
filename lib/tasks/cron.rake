task :cron => :environment do
  Rake::Task['cmu:import_courses'].invoke
end
