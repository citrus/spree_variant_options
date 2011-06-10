@no-txn @javascript
Feature: Products should have variant options
  A Product's variants should be broken out into options
  
  Scenario: When visiting a product
    Given I have a product with variants
    And I'm on the product page for the first product
    Then the source should contain the options hash
    And I wait for 2 seconds
        