Feature: Division
  In order to avoid silly mistakes
  As a math idiot
  I want to be told the quotient of two numbers

  Scenario: Divide two numbers
    Given I have entered 6 into the calculator
    And I have entered 2 into the calculator
    When I divide
    Then the result should be 3
