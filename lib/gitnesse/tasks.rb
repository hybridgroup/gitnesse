desc "Update features from remote repository and run cucumber."
task :gitnesse => :environment do
  Gitnesse.perform
end