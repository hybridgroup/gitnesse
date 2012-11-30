require_relative '../../test_helper'

describe Gitnesse do
  describe "#load_feature_files_into_wiki" do
    let(:wiki) { mock() }
    let(:wiki_page) { mock() }
    let(:tmpdir) { Dir.mktmpdir }
    let(:feature_file_dir) { Dir.mktmpdir }

    before do
      # create test feature
      File.open(File.join(feature_file_dir, "test.feature"), "w") do |file|
        feature = <<-EOF
Feature: Addition
  In order to avoid silly mistakes
  As a math idiot
  I want to be told the sum of two numbers

  Scenario: Add two numbers
    Given I have entered 50 into the calculator
    And I have entered 70 into the calculator
    When I press add
    Then the result should be 120 on the screen
        EOF

        file.write(feature)
      end

      Dir.expects(:glob).with("#{Gitnesse.configuration.target_directory}/*.feature").returns(:feature_file_dir)
      wiki.expects(:page).with("testing").returns(wiki_page)
      Gitnesse.expects(:update_wiki_page).with(wiki_page, "testing", "blarg")
    end
  end
end
