require 'spec_helper'

module Gitnesse
  describe ConvertsFeatureToMarkdown do
    let(:feature_to_convert) { example_feature }
    let(:expected_result) do
      <<-EOS.chomp
# Addition

```gherkin
Feature: Addition
  In order to avoid silly mistakes
  As a math idiot
  I want to be told the sum of two numbers

  Scenario: Add two numbers
    Given I have entered 50 into the calculator
    And I have entered 70 into the calculator
    When I press add
    Then the result should be 120 on the screen
```
      EOS
    end

    describe ".convert" do
      it "converts a Cucumber feature to a Markdown wiki page" do
        wiki_page = ConvertsFeatureToMarkdown.convert(example_feature)
        expect(wiki_page).to eq expected_result
      end
    end
  end
end
