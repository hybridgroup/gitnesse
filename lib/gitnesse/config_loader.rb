module Gitnesse
  class ConfigLoader
    class ConfigFileError < StandardError ; end

    def self.find_and_load
      possible_config_files = Dir.glob(File.join("**", "gitnesse.rb"))

      files_with_config = possible_config_files.select do |file_name|
        if File.fnmatch("vendor/**/*.rb", file_name)
          false
        else
          file_content = File.read(file_name)
          file_content.match("Gitnesse::Config.config do")
        end
      end

      case files_with_config.length
      when 0
        raise ConfigFileError, "Can't find a gitnesse.rb file with Gitnesse configuration."
      when 1
        load(File.absolute_path(files_with_config.first))
      else
        raise ConfigFileError, "Several config files found: #{files_with_config.join(", ")}"
      end
    end
  end
end
