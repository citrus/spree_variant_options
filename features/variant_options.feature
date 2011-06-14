@no-txn @javascript
Feature: Products should have variant options
  A Product's variants should be broken out into options
  
  Scenario: Display options when visiting a product
    Given I have a product with variants
    And I'm on the product page for the first product
    Then the source should contain the options hash
    And I should see enabled links for the first option type
    And I should see disabled links for the second option type
    And I should have a hidden input for the selected variant
    And the add to cart button should be disabled
  
  Scenario: Interact with options for a product
    Given I have a product with variants
    And I'm on the product page for the first product
    When I follow "Small" within the first set of options
    Then I should see enabled links for the second option type
    And the add to cart button should be disabled
    When I follow "Green" within the second set of options
    Then the add to cart button should be enabled
    When I follow "Medium" within the first set of options
    And I should see enabled links for the second option type
    And the add to cart button should be disabled
    When I follow "Red" within the second set of options
    And the add to cart button should be enabled
      
  Scenario: Should show out of stock for appropriate variants
    Given I have a product with variants
    And the "Small Green" variant is out of stock
    And I'm on the product page for the first product
    When I follow "Small" within the first set of options
    Then I should see an out-of-stock link for "Green"
    And I should see an in-stock link for "Red, Blue, Black, White, Gray"
  
  Scenario: Should clear current selection
    Given I have a product with variants
    And I'm on the product page for the first product
    When I follow "Small" within the first set of options
    And I click the current clear button
    Then I should see disabled links for the second option type
    And I should see enabled links for the first option type
          
  Scenario: Should clear current selection and maintain parent selection 
    Given I have a product with variants
    And I'm on the product page for the first product
    When I follow "Small" within the first set of options
    And I follow "Green" within the second set of options
    Then the add to cart button should be enabled
    And I click the last clear button
    Then I should see "Small" selected within the first set of options
    And I should see enabled links for the second option type
    And the add to cart button should be disabled
          
  Scenario: Should clear current selection and parent selection 
    Given I have a product with variants
    And I'm on the product page for the first product
    When I follow "Small" within the first set of options
    And I follow "Green" within the second set of options
    Then the add to cart button should be enabled
    And I click the first clear button
    Then I should not see a selected option
    And I should see disabled links for the second option type
    And I should see enabled links for the first option type
    And the add to cart button should be disabled
            
  Scenario: Should add proper variant to cart
    Given I have a product with variants
    And I'm on the product page for the first product
    When I follow "Small" within the first set of options
    And I follow "Green" within the second set of options
    Then the add to cart button should be enabled
    And I press "Add To Cart"
    Then I should be on the cart page
    And I should see "Size: Small, Color: Green"
    
  Scenario: Should auto-select one variant products
    Given I have a product with variants
    And I have an "XXL Turquoise" variant
    And I'm on the product page for the first product
    When I follow "XXL" within the first set of options
    Then I should see "Turquoise" selected within the second set of options
    And the add to cart button should be enabled
      