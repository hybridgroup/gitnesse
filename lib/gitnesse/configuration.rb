module Gitnesse
  class Configuration
    attr_accessor :repository_url
    attr_accessor :branch
    attr_accessor :target_directory
    attr_accessor :annotate_results
    attr_accessor :info

    class NoConfigFileError < StandardError ; end
    class MultipleConfigFileError < StandardError ; end

    def initialize
      @branch = 'master'
      @target_directory = File.join(Dir.pwd, 'features')
      @annotate_results = false
      @info = nil
    end

    # Public: Returns the current Gitnesse configuration as a Hash
    #
    # Returns a hash containing the current Gitnesse configuration
    def to_hash
      { 'repository_url'   => @repository_url,
        'branch'           => @branch,
        'target_directory' => @target_directory }
    end

    def self.load_using_search
      load(ENV['GITNESSE_CONFIG']) and return if ENV['GITNESSE_CONFIG']

      possible_config_files = Dir.glob(File.join("**", "gitnesse.rb"))

      files_with_config = possible_config_files.select do |file_name|
        if FileUtils.compare_file(__FILE__, file_name)
          false
        elsif File.fnmatch("vendor/**/*.rb", file_name)
          false
        else
          file_content = File.read(file_name)
          file_content.match("Gitnesse.configure")
        end
      end

      case files_with_config.length
        when 0
          raise NoConfigFileError, "Can't find a gitnesse.rb file with Gitnesse configuration."
        when 1
          load(File.absolute_path(files_with_config.first))
        else
          raise MultipleConfigFileError, "Several config files found: #{files_with_config.join(", ")}"
      end
    end
  end
end
