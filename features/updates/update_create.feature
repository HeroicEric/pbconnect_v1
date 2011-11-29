Feature: Create an Update

  @wip
  Scenario: User creates a status update
    Given I am a user named "foo" with an email "user@test.com" and password "please"
    When I sign in as "user@test.com/please"
    Then I should be signed in
    When I visit to the dashboard
    And I fill in "update_form" with "I just had Dunkaroos for lunch!"
    And I press "Share"
    Then I should see "Update shared."
    When I visit "Profile"
    Then I should see "I just had Dunkaroos for lunch!"