require 'singleton'

module Gitnesse
  class Config
    include Singleton

    ConfigStruct = Struct.new :repository_url, :features_dir, :branch,
                              :annotate_results, :identifier

    # Config Options:
    #
    # repository_url   - URl to remote git-based wiki.
    # features_dir     - directory for local features. Defaults to "features"
    # branch           - git branch of remote git-based wiki to use. Defaults to
    #                    'master'
    # annotate_results - boolean, determines if Gitnesse will annotate cucumber
    #                    results to wiki pages. Defaults to false
    # identifier       - if annotate_results is checked, an identifier to use
    #                    to indicate who ran the cukes.
    #                    e.g. "Uncle Bob's MacBook Air"

    @@config = ConfigStruct.new

    # default config options
    @@config.annotate_results = false
    @@config.branch = 'master'
    @@config.features_dir = 'features'

    # Allows external configuration of the ConfigStruct using a block.
    #
    # Accepts a block for config options
    #
    # Returns the current configuration
    #
    # Example:
    #   @config = Gitnesse::Config.instance
    #
    #   Gitnesse::Config.config do |config|
    #     config.annotate_results = true
    #   end
    #
    #   @config.annotate_results #=> true
    def self.config
      yield @@config if block_given?
      Hash[@@config.each_pair.to_a]
    end

    # Converts the current configuration option to a hash
    #
    # Returns a hash
    def to_h
      Hash[@@config.each_pair.to_a]
    end

    # Method_missing used to make it easier to access ConfigStruct values
    #
    # Example:
    #   @config = Gitnesse::Config.instance
    #   @config.annotate_results #=> false
    def method_missing(method, *args, &block)
      if @@config.respond_to?(method)
        @@config.send(method, *args, &block)
      else
        raise NoMethodError
      end
    end
  end
end
