module Gitnesse
  class FeatureExtractor

    # Extracts Cucumber features from a Markdown-formatted string
    #
    # string - Markdown-formatted string to find Cucumber features in
    #
    # Returns an array of matches
    def self.extract!(string)
      matches = string.scan(/\u0060{3}gherkin\s*(.+?)\u0060{3}/im).flatten

      if matches.any?
        # Remove newline characters from beginning/end of each feature
        matches.map { |m| m.lstrip! ; m.chomp! }
      else
        []
      end
    end

    # Checks if a string contains a Cucumber feature
    #
    # string - Markdown-formatted string to check for Cucumber features in
    #
    # Returns true if there are features, false otherwise
    def self.contains_features?(string)
      string.scan(/\u0060{3}gherkin\s*(.+?)\u0060{3}/im).flatten.any?
    end
  end
end
