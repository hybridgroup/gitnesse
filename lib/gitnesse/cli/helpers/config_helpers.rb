module Gitnesse
  class Cli
    module ConfigHelpers
      # Loads and checks Gitnesse configuration/dependencies
      #
      # Returns an instance of Gitnesse::Config
      def load_and_check_config
        Gitnesse::ConfigLoader.find_and_load
        Gitnesse::DependencyChecker.new.check
      end
    end
  end
end
