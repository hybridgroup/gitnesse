module Gitnesse
  class FeatureTransform

    # Converts a Cucumber feature into a Markdown string compatible with
    # Github's Wiki system
    #
    # feature - Cucumber feature to convert to Markdown
    #
    # Returns a string
    def self.convert(feature)
      unless feature.scan(/^\s*?Feature\:(.+?)\n/).flatten.any?
        return <<-EOS.chomp
# Undefined Feature

This feature hasn't been added yet.
        EOS
      end

      title = feature.scan(/^\s*?Feature\:(.+?)\n/).flatten.first.lstrip.chomp

      <<-EOS.chomp
# #{title}

```gherkin
#{feature.chomp}
```
      EOS
    end
  end
end
