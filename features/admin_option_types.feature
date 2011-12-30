@javascript @admin
Feature: Admin option type values
   
  In order to make selectable options
  As an admin
  I want to manage option type values
  
  Background:
    Given I have a product with variants
  
  Scenario: Index option values
    Given I'm on the edit admin option type page for option type "Size"
    Then I should see option values for small, medium, large and x-large
  
  Scenario: Create a new option values
    Given I'm on the edit admin option type page for option type "Size"
    Then I follow "Add Option Value"
      And I fill in the option value fields for the new option value
    When I press "Update"
    Then I should see option values for small, medium, large, x-large and xxx-large
      And I should see image "1.jpg"

  Scenario: Update an existing option value
    Given I'm on the edit admin option type page for option type "Size"
    When I fill in the option value fields for option value "Medium"
      And I press "Update"
    Then I should see option values for small, large, x-large and xxx-large
      And I should see image "1.jpg"

  Scenario: Delete an existing option value
    Given I'm on the edit admin option type page for option type "Size"
    When I follow "Remove" for option type "Small"
      And I press "Update"
    Then I should see option values for medium, large and x-large
  
  # Can't get capybara to play nicely with sortables...
  #@wip
  #Scenario: Sort existing option values
  #  Given I'm on the edit admin option type page for option type "Size"
  #  When I drag option value "Large" to the top
  #    And I reload the page
  #  Then I should see "Large" as the first option value
   
   