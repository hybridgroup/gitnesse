module Gitnesse
  class DependencyChecker
    attr_reader :errors

    def initialize
      @errors = []
    end

    def check
      check_git
      check_cucumber
      check_repository_url
      check_identifier
      check_features_dir_exists

      display_errors if @errors.any?
    end

    def add_error(message)
      @errors << message
    end

    def display_errors
      puts "Configuration errors were found!"
      @errors.each { |error| puts "  - #{error}" }
      abort
    end

    # Checks that Git is installed on the system.
    #
    # Returns true or raises DependencyNotMetError if git is broken
    def check_git
      if system("git --version &> /dev/null")
        true
      else
        add_error "Git not found or not working"
      end
    end

    # Checks that Cucumber is installed on the system.
    #
    # Returns true or raises DependencyNotMetError if Cucumber is broken
    def check_cucumber
      if system("cucumber --version &> /dev/null")
        true
      else
        add_error "Cucumber not found or not working"
      end
    end

    # Checks that repository_url is set in Gitnesse::Config.
    #
    # Returns true or raises DependencyNotMetError if repository_url isn't set
    def check_repository_url
      url = Gitnesse::Config.instance.repository_url
      if url.nil? || url.empty?
        add_error "You must specify a repository_url to run Gitnesse"
      else
        true
      end
    end

    # Checks that identifier is set in Gitnesse::Config, if annotate_results is
    # set.
    #
    # Returns true or raises DependencyNotMetError if identifier isn't set
    def check_identifier
      return true unless Gitnesse::Config.instance.annotate_results
      identifier = Gitnesse::Config.instance.identifier
      if identifier.nil? || identifier.empty?
        add_error "You must specify identifier to use the annotate_results option"
      else
        true
      end
    end

    def check_features_dir_exists
      dir = Gitnesse::Config.instance.features_dir
      if File.directory?(dir)
        true
      else
        add_error "The features directory './#{dir}' does not exist."
      end
    end
  end
end
