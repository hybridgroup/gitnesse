require_relative '../../test_helper'

describe Gitnesse do
  describe ".extract_features" do
    let(:data) do
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

    let(:expected_result) do
      { "addition" => "Feature: Addition
  In order to avoid silly mistakes
  I want to be told the sum of two numbers

  Scenario: Add two single digit numbers
    Given I have entered 7 into the calculator
    And I have entered 5 into the calculator
    When I add
    Then the result should be 12 on the screen
"}
    end

    let(:method) { lambda { Gitnesse.extract_features(data) } }

    it { method.call.must_be_instance_of Hash }

    it "extracts feature data" do
      method.call.must_equal expected_result
    end
  end
end
