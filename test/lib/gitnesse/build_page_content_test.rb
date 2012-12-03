require_relative '../../test_helper'

describe Gitnesse::Wiki do
  let(:dir) { Dir.mktmpdir }
  let(:wiki) { Gitnesse::Wiki.new(dir) }

  before do
    Dir.chdir(dir) do
      `git init`
    end
  end

  describe ".build_page_content" do
    let(:wiki_page_content) do
      <<-EOS
# Addition is Awesome

```gherkin
Feature: Addition
  In order to avoid silly mistakes
  I want to be told the sum of two numbers

  Scenario: Add two single digit numbers
    Given I have entered 7 into the calculator
    And I have entered 5 into the calculator
    When I add
    Then the result should be 12 on the screen
```
      EOS
    end

    let(:new_feature_content) do
      <<-EOS
Feature: Addition
  In order to avoid silly mistakes
  I want to be told the sum of two numbers

  Scenario: Add two double digit numbers
    Given I have entered 50 into the calculator
    And I have entered 70 into the calculator
    When I add
    Then the result should be 120 on the screen
      EOS
    end

    describe "without existing wiki page content" do
      let(:method) { lambda { wiki.build_page_content(new_feature_content) } }
      let(:expected_result) do
        "```gherkin
Feature: Addition
  In order to avoid silly mistakes
  I want to be told the sum of two numbers

  Scenario: Add two double digit numbers
    Given I have entered 50 into the calculator
    And I have entered 70 into the calculator
    When I add
    Then the result should be 120 on the screen

```"
      end

      it { method.call.must_equal expected_result }
    end

    describe "with existing wiki page content" do
      let(:method) { lambda { wiki.build_page_content(new_feature_content, wiki_page_content) } }
      let(:expected_result) do
        <<-EOS
# Addition is Awesome

```gherkin
Feature: Addition
  In order to avoid silly mistakes
  I want to be told the sum of two numbers

  Scenario: Add two double digit numbers
    Given I have entered 50 into the calculator
    And I have entered 70 into the calculator
    When I add
    Then the result should be 120 on the screen
```
        EOS
      end

      it { method.call.must_equal expected_result }
    end
  end
end
