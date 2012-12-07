require_relative '../../test_helper'

describe Gitnesse::Wiki do
  describe "#append_results" do
    let(:dir) { Dir.mktmpdir }
    let(:wiki) { mock }
    let(:feature_file) do
      <<-EOS
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
    let(:pages) do
      [
        stub(
          :name      => "addition",
          :text_data => feature_file,
          :raw_data  => feature_file
        )
      ]
    end
    let(:cucumber_scenario) do
      stub(
        :name => "Add two single digit numbers",
        :status => :passed,
        :feature => stub(:file => "addition.feature")
      )
    end

    let(:method) { lambda { Gitnesse::Wiki.new(dir).append_results(cucumber_scenario) } }

    before do
      Gollum::Wiki.expects(:new).returns(wiki)
      wiki.expects(:pages).returns(pages)
      wiki.expects(:update_page).returns(true)
      File.expects(:basename).returns("addition")
    end

    it { puts method.call.must_include "Last result was PASSED: Add two single digit numbers" }
  end
end
