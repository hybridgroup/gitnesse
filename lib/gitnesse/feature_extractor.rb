module Gitnesse
  class FeatureExtractor

    # Extracts Cucumber features from a Markdown-formatted string
    #
    # string - Markdown-formatted string to find Cucumber features in
    #
    # Returns an array of strings or false if no feature found
    def self.extract!(string)
      matches = string.scan(/\u0060{3}gherkin(.+?)\u0060{3}/m).flatten

      if matches.any?
        # Remove newline characters from beginning/end of each feature
        matches.map { |m| m.lstrip! ; m.chomp! }
      else
        false
      end
    end
  end
end
