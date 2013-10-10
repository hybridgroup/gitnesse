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

      if scenario.respond_to?(:scenario_outline)
        file = scenario.scenario_outline.file.gsub(/^#{@config.features_dir}\//, '')
        name = scenario.name.split("|")
        name.shift
        name = name.map! { |s| s.strip.lstrip }
        name = "#{scenario.scenario_outline.name} - (#{name.join(', ')})"
      else
        file = scenario.file.gsub(/^#{@config.features_dir}\//, '')
        name = scenario.name
      end

      page = file.gsub("/", " > ")
      status = scenario.status

      @wiki = Gitnesse::Wiki.new(@config.repository_url, dir, clone: false)
      page = @wiki.pages.find { |f| f.wiki_path.include?(page) }

      return unless page

      page.append_result name, status
      @wiki.repo.add(page.wiki_path)
    end
  end
end
