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
  end
end
