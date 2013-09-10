@pull
Feature: Pull
  Scenario: Features already exist in remote wiki, but not locally
    Given there is a wiki with Cucumber features defined
    And there are no local features
    When I pull features
    Then the local features should match the wiki

  Scenario: Features exist both in remote wiki and locally
    Given there is a wiki with Cucumber features defined
    And there are local features
    When I pull features
    Then the local features should match the wiki