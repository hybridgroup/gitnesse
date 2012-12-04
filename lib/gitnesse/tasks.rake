namespace :gitnesse do
  task :environment do
  end

  desc "Pull features from remote repository and run cucumber."
  task :run => :environment do
    Gitnesse::Configuration.load_using_search
    Gitnesse.run
  end

  desc "Pull features from remote git wiki repository."
  task :pull => :environment do
    Gitnesse::Configuration.load_using_search
    Gitnesse.pull
  end

  desc "Push features to remote git wiki repository."
  task :push => :environment do
    Gitnesse::Configuration.load_using_search
    Gitnesse.push
  end

  desc "Dump the current config info to the console."
  task :info => :environment do
    Gitnesse::Configuration.load_using_search
    puts Gitnesse.configuration.to_yaml
  end
end
