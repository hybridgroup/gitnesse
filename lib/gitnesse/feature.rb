module Gitnesse
  class Feature
    attr_accessor :filename

    def initialize(filename)
      @filename = filename
      @config = Gitnesse::Config.instance
    end

    # Public: Converts feature filename into the filename used on the remote
    # git-based wiki
    #
    # Returns the converted filename
    def wiki_filename
      "features/#{@filename}.md".gsub('/', ' > ')
    end

    # Public: Reads the feature's contents. Caches result so only reads from FS
    # first time it's called.
    #
    # Returns a string
    def read
      @content ||= File.read("#{@config.features_dir}/#{@filename}")
    end

    # Public: Writes updated content to the feature, or creates a new feature if
    # it doesn't exist.
    #
    # content - The new/updated content to write to the file
    #
    # Returns the passed content
    def write(content)
      File.open("#{@config.features_dir}/#{@filename}", 'w') do |f|
        f.write content
      end

      @content = nil

      content
    end

    # Public: Generates the path to the index page the feature would appear on.
    # Used to group Features for creating index pages.
    #
    # Returns a string indicating the index page.
    def index_page
      p = wiki_filename.scan(/^(features\ \>\ .+) >/).flatten[0] || 'features'
      p + ".md"
    end

    # Public: Generates relative link for wiki index pages.
    #
    # Returns a string containing the relative link as markdown
    def relative_link
      "[[#{wiki_filename.gsub('.md', '')}]]"
    end
  end
end
