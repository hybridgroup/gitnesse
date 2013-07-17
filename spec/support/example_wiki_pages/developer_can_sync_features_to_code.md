# Developer Can Sync Features To Code

```Gherkin
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

```gherkin
Feature: Division
  In order to avoid silly mistakes
  As a math idiot
  I want to be told the quotient of two numbers

  Scenario: Divide two numbers
    Given I have entered 6 into the calculator
    And I have entered 2 into the calculator
    When I divide
    Then the result should be 3
```

![](https://s3.amazonaws.com/gitnesse/github/passing.png) `Last result was PASSED: Features already exist in wiki but not in code (2013-01-01 00:00:00 -0800 - Developer Computer)`
