require "minitest/matchers"
require "minitest/autorun"
require "minitest/pride"
require "mocha"
require File.expand_path('../../lib/gitnesse.rb', __FILE__)

module FeatureTestMethods

  # Creates a basic test feature
  #
  # Returns a string
  def create_test_feature
    <<-EOF
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
  end
end
