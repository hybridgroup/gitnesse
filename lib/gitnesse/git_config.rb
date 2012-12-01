module Gitnesse
  class GitConfig
    class NoValueSetError < StandardError ; end

    # Public: Reads a value from the system's git config.
    #
    # key - the value to look up from the git config
    #
    # Returns a string containing the git config value or GitConfigNotFoundError
    def self.read(key)
      value = get_from_git_config key

      if value.empty? || value == ''
        raise NoValueSetError, "Cannot read git config value for #{key}"
      end

      value
    end

    private

    # Private: Tries to fetch a value using git config --get
    #
    # key - the value to look up from the git config
    #
    # Returns a string containing the value supplied by git
    def self.get_from_git_config(key)
      value = ''

      value = `git config --get #{key}`

      if value.empty? || value == ''
        value = `git config --get --global #{key}`
      end

      value.strip
    end
  end
end
