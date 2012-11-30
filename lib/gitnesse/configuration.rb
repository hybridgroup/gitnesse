module Gitnesse
  class Configuration
    attr_accessor :repository_url
    attr_accessor :branch
    attr_accessor :target_directory

    def initialize
      @branch = 'master'
      @target_directory = File.join(Dir.pwd, 'features')
    end

    # Public: Returns the current Gitnesse configuration as a Hash
    #
    # Returns a hash containing the current Gitnesse configuration
    def to_hash
      { 'repository_url'   => @repository_url,
        'branch'           => @branch,
        'target_directory' => @target_directory }
    end
  end
end
