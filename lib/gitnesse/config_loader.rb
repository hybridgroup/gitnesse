module Gitnesse
  class ConfigLoader
    def self.find_and_load
      files = Dir.glob(File.join("**", "gitnesse.rb"))

      files = reject_irrelevant_files files

      files_with_config = files.select do |file_name|
        file_content = File.read(file_name)
        file_content.match("Gitnesse::Config.config do")
      end

      case files_with_config.length
      when 0
        raise_error "Can't find a gitnesse.rb file with Gitnesse configuration."
      when 1
        load(File.absolute_path(files_with_config.first))
      else
        raise_error "Multiple configuration files found:", files_with_config
      end
    end

    private
    def self.reject_irrelevant_files(files)
      files.reject { |f| !!(File.absolute_path(f) =~ /.*(spec|vendor).*/) }
    end

    def self.raise_error(message, files = nil)
      puts message
      files.each { |f| puts f } if files
      exit 1
    end
  end
end
