Feature: Using the Backbone.Fixins.SuperView

  Background:
    Given I'm at the site's root page

  Scenario: loading the simple view
    When I click "Simple SuperView Subclass"
    Then I should see "I'm a simple use of Backbone.Fixins.SuperView!"

    When I click "<- Back"
    Then I should see "Welcome"