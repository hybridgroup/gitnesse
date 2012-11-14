require "rake"
require "rake/tasklib"

module Gitnesse
  class Tasks < ::Rake::TaskLib
    def initialize
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
      end
    end
  end
end
