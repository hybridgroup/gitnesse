module Gitnesse
  class Wiki
    class Page
      attr_reader :name, :filename, :path

      # Public: Creates a new Wiki Page object. Contains references to the page
      # and an easy way to access/update relevant page data.
      #
      # path - full path to the file
      #
      # Returns a Wiki::Page object
      def initialize(path)
        @path = path
        @filename = File.basename path
        @name = File.basename path, ".md"
      end
    end
  end
end
