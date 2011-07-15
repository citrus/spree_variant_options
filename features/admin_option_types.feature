@wip @no-txn @javascript @admin
Feature: Admin option types
  
  Option types should be sortable and they should have images
 
  Scenario: Index option values
    Given I have a product with variants
      And I'm on the edit admin option type page for option type "size"
