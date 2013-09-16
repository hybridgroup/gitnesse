require 'fileutils'

module Gitnesse
  class DirManager
    # Public: Checks/Creates ~/.gitnesse/{{project_name}} dir.
    # The project name is derived from the folder gitnesse is run in.
    #
    # Returns the path to the created project dir
    def self.make_project_dir
      FileUtils.mkdir_p project_dir
      project_dir
    end

    # Public: Removes project dir, but not ~/.gitnesse dir
    #
    # Returns nothing
    def self.remove_project_dir
      FileUtils.rm_rf project_dir
    end

    # Public: Checks that project directory is present
    #
    # Returns a boolean indicating if the dir exists or not
    def self.project_dir_present?
      File.directory? project_dir
    end

    private
    # Private: Constructs project dir path in ~/.gitnesse folder
    #
    # Returns a string path
    def self.project_dir
      @project_dir ||= begin
        "#{Dir.home}/.gitnesse/#{File.basename(Dir.pwd)}"
      end
    end
  end
end
