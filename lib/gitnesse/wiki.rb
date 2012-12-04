module Gitnesse
  class Wiki
    attr_accessor :wiki

    def initialize(dir = Dir.mktmpdir)
      @wiki = Gollum::Wiki.new(dir)
      @commit_info = Gitnesse.generate_commit_info
    end

    # Public: Loads the provided feature files into the wiki
    #
    # feature_files - a collection of files to search for features
    #                 e.g. Dir.glob("./features/**/*.feature")
    #
    def load_feature_files(feature_files)
      return if feature_files.nil?

      feature_files.each do |feature_file|
        feature_name    = File.basename(feature_file, ".feature")
        feature_content = File.read(feature_file)
        wiki_page       = @wiki.page(feature_name)
        wiki_page       ||= @wiki.page("#{feature_name}.feature")

        if wiki_page
          update_wiki_page(wiki_page, feature_name, feature_content)
        else
          create_wiki_page(feature_name, feature_content)
        end
      end
    end

    # Public: Returns the Wiki's pages
    #
    # Returns an array of Wiki pages
    def pages
      @wiki.pages
    end

    # Public: Extracts gherkins from wiki page
    #
    # page - Wiki page to get features from
    #
    # Returns a hash of Cucumber features
    def self.extract_features(page)
      data = page.respond_to?(:raw_data) ? page.raw_data : page
      features = {}

      if match_result = data.match(/\u0060{3}gherkin(.+)\u0060{3}/m)
        captures = match_result.captures

        # create hash with feature name as key and feature text as value
        captures.each do |capture|
          feature_definition_at = capture.index('Feature:')
          feature_text = capture[feature_definition_at,capture.size-1]
          feature_lines = feature_text.split("\n")
          feature_definition = feature_lines.grep(/^Feature:/).first

          if feature_definition
            feature_name = feature_definition.split(":").last.strip.gsub(" ","-").downcase
            features[feature_name] = feature_text
          end
        end
      end

      features
    end

    # Public: Builds wiki page content
    #
    # feature_content - Content to generate the page content from
    # old_page_content - old page content to replace with new page content
    #
    # Returns a string containing the generated page content
    def build_page_content(feature_content, old_page_content = nil)
      content = "```gherkin\n#{feature_content}\n```"
      return content if old_page_content.nil? || old_page_content.empty?

      features = Wiki.extract_features(old_page_content)

      _, old_feature_content = features.shift
      old_page_content.sub(old_feature_content, feature_content)
    end

    private

    # Private: Creates a new wiki page for the provided name and content
    #
    # name - the name of the page to create
    # content - the content the page should have
    #
    # Returns the newly created wiki page
    def create_wiki_page(name, content)
      new_page_content = build_page_content(content)
      @wiki.write_page(name, :markdown, new_page_content, @commit_info)
      puts "  # Created Page: #{name}"
    end

    # Private: Updates a wiki page with the provided name and content
    #
    # wiki_page - the page to update
    # page_name - the name of the page
    # feature_content - the feature content to compare/update
    #
    # Returns the page
    def update_wiki_page(wiki_page, page_name, feature_content)
      wiki_page_content = wiki_page.raw_data
      new_page_content  = build_page_content(feature_content, wiki_page_content)

      if new_page_content == wiki_page_content
        puts "  # Page #{page_name} didn't change"
      else
        @wiki.update_page(wiki_page, page_name, :markdown, new_page_content, @commit_info)
        puts "  # Updated Page: #{page_name}"
      end
    end
  end
end
