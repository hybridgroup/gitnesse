module Gitnesse
  class FeatureExtractor

    # Extracts Cucumber features from a Markdown-formatted string
    #
    # string - Markdown-formatted string to find Cucumber features in
    #
    # Returns an array of matches
    def self.extract!(string)
      matches = string.scan(/\u0060{3}gherkin(.+?)\u0060{3}/im).flatten

      if matches.any?
        # Remove newline characters from beginning/end of each feature
        matches.map { |m| m.lstrip! ; m.chomp! }
      else
        []
      end
    end
  end
end
