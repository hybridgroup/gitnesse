module Gitnesse
  class Dependencies
    class NoGitError < StandardError ; end
    class NoCucumberError < StandardError ; end
    class NoRepositoryURLError < StandardError ; end

    # Checks Gitnesse's dependencies, and throws an error if one of them is
    # missing.
    def self.check
      check_git
      check_cucumber
      check_repository_url
    end

    protected

    def self.check_git
      raise NoGitError, "git not found or not working." unless Kernel.system("git --version")
    end

    def self.check_cucumber
      raise NoCucumberError, "cucumber not found or not working." unless Kernel.system("cucumber --version")
    end

    def self.check_repository_url
      raise NoRepositoryURLError, "You must select a repository_url to run Gitnesse." if Gitnesse.configuration.repository_url.nil?
    end
  end
end
