require 'gitnesse'
require 'gitnesse/cli/task'

require 'rake'
require 'rake/tasklib'

module Gitnesse
  class Tasks < ::Rake::TaskLib
    load File.dirname(__FILE__) + "/rake/tasks.rake"
  end
end
