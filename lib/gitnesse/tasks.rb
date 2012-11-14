require "rake"
require "rake/tasklib"

module Gitnesse
  class Tasks < ::Rake::TaskLib
    load File.dirname(__FILE__) + '/tasks.rake'
  end
end