SUPPORT_FILES_DIR = File.join(File.dirname(__FILE__), "/support")

Dir[File.join(File.dirname(__FILE__), "support", "*.rb")].each { |f| require(f) }

class Support
  class << self
    def example_config_file_path
      "#{SUPPORT_FILES_DIR}/example_config/gitnesse.rb"
    end

    def example_config_file
      @example_config ||= begin
        File.read(example_config_file_path)
      end
    end

    def addition_feature
      @addition ||= begin
        File.read("#{SUPPORT_FILES_DIR}/example_features/addition.feature")
      end.lstrip.chomp
    end

    def wiki_addition_feature
      <<-EOS.chomp
# Addition

```gherkin
#{addition_feature}
```
      EOS
    end

    def division_feature
      @division ||= begin
        File.read "#{SUPPORT_FILES_DIR}/example_features/division.feature"
      end.lstrip.chomp
    end

    def wiki_division_feature
      <<-EOS.chomp
# Division

```gherkin
#{division_feature}
```
      EOS
    end

    def example_features
      [addition_feature, division_feature]
    end

    def example_wiki_page
      @example_wiki ||= begin
        File.read "#{SUPPORT_FILES_DIR}/example_wiki_pages/developer_can_sync_features_to_code.md"
      end
    end

    def example_wiki_page_features
      [addition_feature, division_feature]
    end
  end
end
