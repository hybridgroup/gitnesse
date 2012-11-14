namespace :gitnesse do
  desc "Pull features from remote repository and run cucumber."
  task :run => :environment do
    Gitnesse.load_config
    Gitnesse.run
  end

  desc "Pull features from remote git wiki repository."
  task :pull => :environment do
    Gitnesse.load_config
    Gitnesse.pull
  end

  desc "Push features to remote git wiki repository."
  task :push => :environment do
    Gitnesse.load_config
    Gitnesse.push
  end

  desc "Dump the current config info to the console."
  task :info => :environment do
    Gitnesse.load_config
    puts Gitnesse.config_to_hash.to_yaml
  end
end