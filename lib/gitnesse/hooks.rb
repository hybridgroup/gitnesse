module Gitnesse
  class Hooks
    @config = Gitnesse::Config.instance

    PATH = File.expand_path("./#{@config.features_dir}/support/gitnesse.rb")

    # Public: Copies Gitnesse Cucumber hooks to Cucumber's support dir.
    #
    # Returns nothing
    def self.create!
      file = File.expand_path("./hooks/gitnesse.rb")
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
