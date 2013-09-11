@push
Feature: Push
  Scenario: Features already exist in local, but not remote wiki
    Given there is a wiki with no Cucumber features defined
    And there are local features
    When I push features
    Then the local features should match the wiki

  Scenario: Features exist both in remote wiki and locally
    Given there is a wiki with Cucumber features defined
    And there are local features
    When I push features
    Then the local features should match the wiki
