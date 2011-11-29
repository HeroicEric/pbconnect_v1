Feature: List Followers

  As a User
  I want to be able to see who is following me
  So that I can know my audience

  @wip
  Scenario: Viewing my own followers
    Given I am a user named "foo" with an email "user@test.com" and password "please"
    And a user named "Fred Friend" exists with an email "fredfriend@test.com"
    And a user named "Ned Notfriend" exists with an email "nednotfriend@test.com"
    And user with email "fredfriend@test.com" is a follower of the user with email "user@test.com"
    When I sign in as "user@test.com/please"
    Then I should be signed in
    When I follow "account_followers"
    Then I should see "Fred Friend"
    And I should not see "Ned Notfriend"