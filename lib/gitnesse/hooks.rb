module Gitnesse
  class Hooks
    @dir = File.join(Dir.home, ".gitnesse")

    # Public: Sets up ~/.gitnesse for appending scenario results
    #
    # Returns nothing
    def self.setup
      Gitnesse::Configuration.load_using_search
      FileUtils.rm_rf(@dir) if File.directory?(@dir)
      Dir.mkdir(@dir)
      `git clone #{Gitnesse.configuration.repository_url} #{@dir}`
      Wiki.new(@dir).remove_past_results
    end

    # Public: Removes ~/.gitnesse after all cukes are run
    #
    # Returns nothing
    def self.teardown
      Dir.chdir(@dir) do
        `git push origin master`
      end

      FileUtils.rm_rf(@dir)
      FileUtils.rm(File.absolute_path("#{Gitnesse.configuration.target_directory}/support/gitnesse_hooks.rb"))
    end

    # Public: Adds hooks into Cucumber
    #
    # Returns nothing
    def self.create
      hook_file   = File.join(File.dirname(__FILE__), "support/hook.rb")
      support_dir = File.absolute_path("#{Gitnesse.configuration.target_directory}/support")
      target_file = File.join(support_dir, "gitnesse_hooks.rb")

      Dir.mkdir(support_dir) unless File.directory?(support_dir)

      File.write(target_file, File.read(hook_file))
    end

    # Public: Appends scenario results to relevant page in wiki
    #
    # scenario - the scenario results from Cucumber
    #
    # Returns nothing
    def self.append_to_wiki(scenario)
      Wiki.new(@dir).append_results(scenario)
    end
  end
end
