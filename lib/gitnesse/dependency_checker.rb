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
      check_commit_info
      check_features_dir_exists

      display_errors if @errors.any?
    end

    def display_errors
      puts "Configuration errors were found!"

      @errors.each do |error|
        puts "  - #{error}"
      end

      exit
    end

    # Checks that Git is installed on the system.
    #
    # Returns true or raises DependencyNotMetError if git is broken
    def check_git
      if system("git --version &> /dev/null")
        true
      else
        @errors << "Git not found or not working"
      end
    end

    # Checks that Cucumber is installed on the system.
    #
    # Returns true or raises DependencyNotMetError if Cucumber is broken
    def check_cucumber
      if system("cucumber --version &> /dev/null")
        true
      else
        @errors << "Cucumber not found or not working"
      end
    end

    # Checks that repository_url is set in Gitnesse::Config.
    #
    # Returns true or raises DependencyNotMetError if repository_url isn't set
    def check_repository_url
      url = Gitnesse::Config.instance.repository_url
      if url.nil? || url.empty?
        @errors << "You must specify a repository_url to run Gitnesse"
      else
        true
      end
    end

    # Checks that commit_info is set in Gitnesse::Config, if annotate_results is
    # set.
    #
    # Returns true or raises DependencyNotMetError if commit_info isn't set
    def check_commit_info
      return true unless Gitnesse::Config.instance.annotate_results
      commit_info = Gitnesse::Config.instance.commit_info
      if commit_info.nil? || commit_info.empty?
        @errors << "You must specify commit_info to use the annotate_results option"
      else
        true
      end
    end

    def check_features_dir_exists
      dir = Gitnesse::Config.instance.features_dir
      if File.directory?(dir)
        true
      else
        @errors << "The features directory './#{dir}' does not exist."
      end
    end
  end
end
