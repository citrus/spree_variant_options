@no-txn
Feature: Products should have variant options
  A Product's variants should be broken out into options
  
  Scenario: When visiting a product
    Given I have a product with variants
    And I'm on the product page for the first product
    
    
    And I wait for 10 seconds
    