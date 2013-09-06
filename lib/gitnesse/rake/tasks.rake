namespace :gitnesse do
  task :environment do
  end

  Gitnesse::Cli.tasks.values.each do |task|
    desc(task.desc) if task.desc
    task task.name.to_sym => :environment do
      task.new(STDOUT).perform
    end
  end
end
