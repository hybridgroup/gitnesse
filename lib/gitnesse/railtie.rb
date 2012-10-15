require 'gitnesse'
require 'rails'

module Gitnesse
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'gitnesse/tasks.rb'
    end
  end
end