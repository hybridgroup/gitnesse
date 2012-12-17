Feature: 
  In order to build software that provides the best fitting solution to a user problem
  As a developer
  I want to be able to test feature stories in my code
  And also store the feature stories in a wiki so users can easily view or edit them

  Scenario: Features already exist in wiki but not in code
    Given there is a code repo without any cucumber features defined
    And there is a git wiki with cucumber features defined
    When developer pulls feature stories from the wiki
    Then the feature stories within the code should match the wiki

  Scenario: Features already exist in code but not in wiki
    Given there is a code repo with cucumber features defined
    And there is a git wiki without any cucumber features defined
    When developer pushes feature stories to the wiki
    Then the feature stories within the code should match the wiki

  Scenario: Features pushes features from code to existing wiki
    Given there is a code repo with cucumber features defined
    And there is a git wiki with cucumber features defined
    When developer pushes feature stories to the wiki
    Then the feature stories within the code should match the wiki

  Scenario: Features pulls features from wiki to existing code
    Given there is a code repo with cucumber features defined
    And there is a git wiki with cucumber features defined
    When developer pulls feature stories from the wiki
    Then the feature stories within the code should match the wiki
