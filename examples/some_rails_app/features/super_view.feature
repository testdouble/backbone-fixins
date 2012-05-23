Feature: Using the Backbone.Fixins.SuperView

  Background:
    Given I'm at the site's root page

  Scenario: a simple example
    When I click "Simple SuperView Subclass"
    Then I should see "I'm a simple use of Backbone.Fixins.SuperView!"

    When I click "<- Back"
    Then I should see "Welcome"

  Scenario: an example with some options selected
    When I click "Complex SuperView Subclass"
    Then I should see "I'm a super complex use of Backbone.Fixins.SuperView!"
    Then I should see "*fine print, though."
    Then I should see "*yet finer print."

    When I click "<- Back"
    Then I should see "Welcome"

  Scenario: an example that overrides the default configuration
    When I click "Customized SuperView Subclass"
    Then I should see "I'm a quite customized use of Backbone.Fixins.SuperView!"

    When I click "<- Back"
    Then I should see "Welcome"
