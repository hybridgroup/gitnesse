require 'singleton'

module Gitnesse
  ConfigStruct = Struct.new :annotate_results, :branch, :commit_info,
                            :features_dir, :repository_url

  class Config
    include Singleton

    @@config = ConfigStruct.new

    @@config.annotate_results = false
    @@config.branch = 'master'
    @@config.features_dir = 'features'

    def self.config
      yield @@config if block_given?
      @@config
    end

    def to_h
      Hash[@@config.each_pair.to_a]
    end

    def method_missing(method, *args, &block)
      if @@config.respond_to?(method)
        @@config.send(method, *args, &block)
      else
        raise NoMethodError
      end
    end
  end
end
