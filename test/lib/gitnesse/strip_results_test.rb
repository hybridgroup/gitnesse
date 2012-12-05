require_relative "../../test_helper"

describe Gitnesse::Wiki do
  describe "#strip_results" do
    let(:wiki_page) do
      <<-EOS
```gherkin
Feature: Division
  In order to avoid silly mistakes
  As a math idiot
  I want to be told the quotient of 2 numbers

  Scenario: Divide two numbers
    Given I have entered 6 into the calculator
    And I have entered 2 into the calculator
    When I divide
    Then the result should be 3
```

UNDEFINED: Divide two numbers

PENDING: Divide two numbers

FAILED: Divide two numbers

PASSED: Divide two numbers
EOS
    end

    let(:expected_result) do
      <<-EOS
```gherkin
Feature: Division
  In order to avoid silly mistakes
  As a math idiot
  I want to be told the quotient of 2 numbers

  Scenario: Divide two numbers
    Given I have entered 6 into the calculator
    And I have entered 2 into the calculator
    When I divide
    Then the result should be 3
```

EOS
    end

    before do
      Gollum::Wiki.expects(:new).returns(mock)
    end

    it "strips old results from the page" do
      Gitnesse::Wiki.new(Dir.mktmpdir).strip_results(wiki_page).must_equal expected_result
    end
  end
end
