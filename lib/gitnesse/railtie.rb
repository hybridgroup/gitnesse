require 'gitnesse'
require 'rails'

module Gitnesse
  class Railtie < Rails::Railtie
    railtie_name :gitnesse

    rake_tasks do
      load File.dirname(__FILE__) + '/tasks.rake'
    end
  end
end
