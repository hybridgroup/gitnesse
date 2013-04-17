module Gitnesse
  class ChecksDependencies
    class DependencyNotMetError < StandardError ; end

    def self.check
      check_git
      check_cucumber
      check_repository_url
      check_commit_info
    end

    # Checks that Git is installed on the system.
    #
    # Returns true or raises DependencyNotMetError if git is broken
    def self.check_git
      if system("git --version &> /dev/null")
        true
      else
        raise DependencyNotMetError, "Git not found or not working"
      end
    end

    # Checks that Cucumber is installed on the system.
    #
    # Returns true or raises DependencyNotMetError if Cucumber is broken
    def self.check_cucumber
      if system("cucumber --version &> /dev/null")
        true
      else
        raise DependencyNotMetError, "Cucumber not found or not working"
      end
    end

    # Checks that repository_url is set in Gitnesse::Config.
    #
    # Returns true or raises DependencyNotMetError if repository_url isn't set
    def self.check_repository_url
      url = Gitnesse::Config.instance.repository_url
      if url.nil? || url.empty?
        raise DependencyNotMetError, "You must specify a repository_url to run Gitnesse"
      else
        true
      end
    end

    # Checks that commit_info is set in Gitnesse::Config, if annotate_results is
    # set.
    #
    # Returns true or raises DependencyNotMetError if commit_info isn't set
    def self.check_commit_info
      return true unless Gitnesse::Config.instance.annotate_results
      commit_info = Gitnesse::Config.instance.commit_info
      if commit_info.nil? || commit_info.empty?
        raise DependencyNotMetError, "You must specify commit_info to use the annotate_results option"
      else
        true
      end
    end
  end
end
