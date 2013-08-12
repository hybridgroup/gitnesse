require 'fileutils'

module Gitnesse
  class DirManager
    # Public: Checks/Creates ~/.gitnesse/{{project_name}} dir.
    # The project name is derived from the folder gitnesse is run in.
    #
    # Returns the path to the created project dir
    def self.make_project_dir
      project_name = File.basename Dir.pwd
      path = "#{Dir.home}/.gitnesse/#{project_name}"
      FileUtils.mkdir_p path
      path
    end

    # Public: Removes project dir, but not ~/.gitnesse dir
    #
    # Returns nothing
    def self.remove_project_dir
      project_name = File.basename Dir.pwd
      FileUtils.rm_rf "#{Dir.home}/.gitnesse/#{project_name}"
    end
  end
end
