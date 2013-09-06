require 'gitnesse'
require 'gitnesse/cli/task'

require 'rails'

module Gitnesse
  class Railtie < Rails::Railtie
    railtie_name :gitnesse

    rake_tasks do
      load File.dirname(__FILE__) + '/rake/tasks.rake'
    end
  end
end
