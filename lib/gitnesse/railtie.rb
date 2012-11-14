require 'gitnesse'
require 'rails'

module Gitnesse
  class Railtie < Rails::Railtie
  	railtie_name :gitnesse

    rake_tasks do
      load 'lib/gitnesse/tasks.rake'
    end
  end
end