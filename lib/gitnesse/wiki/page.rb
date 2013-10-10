module Gitnesse
  class Wiki
    class Page
      attr_reader :wiki_path, :path, :filename, :relative_path

      # Public: Creates a new Wiki Page object. Contains references to the page
      # and an easy way to access/update relevant page data.
      #
      # path - full path to the file
      #
      # Returns a Wiki::Page object
      def initialize(path)
        @wiki_path = path
        @relative_path = get_relative_path
        @filename = get_filename
        @path = "#{@relative_path}/#{@filename}".gsub("//", "/")
      end

      # Public: Reads the file's contents. Caches result so only reads from FS
      # first time it's called per page.
      #
      # Returns a string
      def read
        @content ||= File.read(@wiki_path)
      end

      # Public: Writes content to the file.
      #
      # Returns the passed content
      def write(content)
        File.open(@wiki_path, 'w+') do |f|
          f.write content
        end

        @content = nil

        content
      end

      # Public: Removes existing results from the feature page.
      #
      # Returns nothing
      def remove_results
        write(read.gsub(/\s+- !\[\].*---/m, ''))
      end

      # Public: Appends the result of a Cucumber scenario to the feature's wiki
      # page.
      #
      # scenario - feature scenario that was run
      # status - return status of the scenario, e.g. :passed, :undefined,
      # :failing
      # subtitle - subtitle of scenario (used for scenario outlines)
      #
      # Returns nothing
      def append_result(scenario, status, subtitle = nil)
        image = "![](//s3.amazonaws.com/gitnesse/github/#{status.to_s}.png)"
        time = Time.now.strftime("%b %d, %Y, %-l:%M %p")
        identifier = Gitnesse::Config.instance.identifier

        string = "\n- #{image} **#{scenario}**".chomp
        string << "\n- **(#{subtitle})**" if subtitle
        string << "\n- #{identifier} - #{time}\n\n---"

        write(read + string)
      end

      protected
      # Protected: Converts wiki-formatted filename into directories containing
      # the page.
      #
      # Wiki filenames are formatted to accomodate nested directories, so for
      # example the local feature "features/thing/thing.feature" would be given
      # the filename "features > thing > thing.feature" in the wiki.
      #
      # path - path to convert
      #
      # Returns a string dir path
      #
      # Examples:
      #   @wiki_path = "features > thing > thing.feature.md"
      #   get_relative_path #=> "./features/thing"
      #
      #   @wiki_path = "thing.feature"
      #   get_relative_path #=> "./features"
      def get_relative_path
        dirs = File.basename(@wiki_path).scan(/(\w+)\ \>/).flatten
        dirs.shift if dirs.first == "features"
        "./#{Gitnesse::Config.instance.features_dir}/#{dirs.join("/")}"
      end

      # Protected: Extracts the local filename for the wiki page
      #
      # Returns a string containing the filename
      #
      # Examples:
      #   @wiki_path = "features > thing > thing.feature.md"
      #   get_filename #=> "thing.feature"
      def get_filename
        File.basename(@wiki_path, '.md').scan(/(\w+\.feature)$/).flatten.first
      end
    end
  end
end
