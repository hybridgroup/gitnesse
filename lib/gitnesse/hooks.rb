module Gitnesse
  class Hooks
    @config = Gitnesse::Config.instance

    DIR = File.expand_path("./#{@config.features_dir}/support")
    PATH = File.expand_path("./#{@config.features_dir}/support/gitnesse.rb")

    # Public: Copies Gitnesse Cucumber hooks to Cucumber's support dir.
    #
    # Returns nothing
    def self.create!
      FileUtils.mkdir_p DIR unless File.directory?(DIR)

      file = File.expand_path("#{File.dirname(__FILE__)}/hooks/gitnesse.rb")
      FileUtils.cp file, PATH
    end

    # Public: Removes existing Gitnesse hooks in Cucumber's support dir
    #
    # Returns nothing
    def self.destroy!
      FileUtils.rm PATH, force: true
    end

    # Public: Used by Gitnesse hook to append results to wiki page for feature
    #
    # scenario - Cucumber scenario passed by post-scenario hook
    #
    # Returns nothing
    def self.append_results(scenario)
      Gitnesse::ConfigLoader.find_and_load
      dir = Gitnesse::DirManager.project_dir

      file = scenario.file.gsub(/^#{@config.features_dir}\//, '')

      page = file.gsub("/", " > ")
      name = scenario.name
      status = scenario.status

      @wiki = Gitnesse::Wiki.new(@config.repository_url, dir, clone: false)
      page = @wiki.pages.find { |f| f.wiki_path.include?(page) }

      return unless page

      page.append_result name, status
    end
  end
end
