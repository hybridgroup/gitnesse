SUPPORT_FILES_DIR = File.join(File.dirname(__FILE__), "/support")

require 'fileutils'
require 'tempfile'
require 'tmpdir'

module CliSpecs
  def gitnesse(args)
    out = StringIO.new
    Gitnesse::Cli.new(out).parse(args.split(/\s+/))

    out.rewind
    out.read
  rescue SystemExit
    out.rewind
    out.read
  end
end

RSpec.configure do |c|
  c.include CliSpecs, type: :cli
end

class Support
  class << self
    def example_config_file
      "#{SUPPORT_FILES_DIR}/example_config/gitnesse.rb"
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

    def wiki_feature_without_annotations
      wiki_division_feature
    end

    def wiki_feature_with_annotations
      <<-EOS.chomp
# Division

```gherkin
#{division_feature}
```
- ![](//s3.amazonaws.com/gitnesse/github/passed.png) **Divide two numbers**
-  - Sep 06, 2013, 10:10 AM

---
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

