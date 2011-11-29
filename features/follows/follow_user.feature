Feature: Follow user

  As a registered user of the website
  I want to be able to follow other users
  So that I can see their updates

  Background:
    Given a user named "Fred Friend" with email "fredfriend@test.com"

  @wip
  Scenario: I follow a User from their profile page
    Given I am logged in
    When I go to the profile page for "fredfriend@test.com"
    And I press "Follow"
    Then I should be following "Fred Friend"

  Scenario: I unfollow a User from their profile page
    Given I am logged in
    When I go to the profile page for "fredfriend@test.com"
    And I press "Unfollow"
    Then I should not be following "Fred Friend"
