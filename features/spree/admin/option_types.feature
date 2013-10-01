@javascript @admin
Feature: Admin option type values
   
  In order to make selectable options
  As an admin
  I want to manage option type values
  
  Background:
    Given I have a product with variants
    And I login as an admin
  
  Scenario: Index option values
    Given I'm on the edit admin option type page for option type "Size"
    Then I should see option values for Small, Medium, Large and X-Large
  
  Scenario: Create a new option value
    Given I'm on the edit admin option type page for option type "Size"
    Then I follow "Add Option Value"
      And I fill in the option value fields for the new option value
    When I press "Update"
    Then I should see option values for Small, Medium, Large, X-Large and XXX-Large
      And I should see image "1.jpg"

  Scenario: Update an existing option value
    Given I'm on the edit admin option type page for option type "Size"
    When I fill in the option value fields for option value "Medium"
      And I press "Update"
    Then I should see option values for Small, Large, X-Large and XXX-Large
      And I should see image "1.jpg"

  Scenario: Delete an existing option value
    Given I'm on the edit admin option type page for option type "Size"
    When I remove option type "Small"
    Then I should see option values for Medium, Large and X-Large
  
  # Can't get capybara to play nicely with sortables...
  #@wip
  #Scenario: Sort existing option values
  #  Given I'm on the edit admin option type page for option type "Size"
  #  When I drag option value "Large" to the top
  #    And I reload the page
  #  Then I should see "Large" as the first option value
   
   