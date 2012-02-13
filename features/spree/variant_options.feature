@javascript
Feature: Products should have variant options
  
  In order to purchase a product
  As a customer
  I want to select a variant
  
  Scenario: Display options when visiting a product
    Given I have a product with variants
      And I'm on the product page for the first product
    Then the source should contain the options hash
      And I should see enabled links for the first option type
      And I should see disabled links for the second option type
      And I should have a hidden input for the selected variant
      And the add to cart button should be disabled
  
  Scenario: Display option images when visiting a product
    Given I have a product with variants
      And the first option type has an option value with image "1.jpg"
      And I'm on the product page for the first product
    Then I should see image "1.jpg" within the first option value
  
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
    Given I don't allow backorders
      And I have a product with variants
      And the "Small Green" variant is out of stock
      And I'm on the product page for the first product
    When I follow "Small" within the first set of options
    Then I should see an out-of-stock link for "Green"
      And I should see an in-stock link for "Red, Blue, Black, White, Gray"
      
  Scenario: Should allow backorders of in stock variants
    Given I allow backorders
      And I have a product with variants
      And the "Small Green" variant is out of stock
      And I'm on the product page for the first product
    When I follow "Small" within the first set of options
    Then I should see an in-stock link for "Green"
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
    
  Scenario: Should auto-select variant if its the only option
    Given I have a product with variants
      And I have an "XXL Turquoise" variant
      And I'm on the product page for the first product
    When I follow "XXL" within the first set of options
    Then I should see "Turquoise" selected within the second set of options
      And the add to cart button should be enabled
    When I follow "Small" within the first set of options  
    Then the add to cart button should be disabled
  
  Scenario: Should adjust price according to variant
    Given I have a product with variants
      And I have an "XXS Turquoise" variant for $29.99
      And I have an "XXS Pink" variant for $24.99
      And I'm on the product page for the first product
    When I follow "XXS" within the first set of options
    Then I should see "$24.99 - $29.99" in the price
    When I follow "Turquoise" within the second set of options
    Then I should see "$29.99" in the price
      And the add to cart button should be enabled
    When I follow "Pink" within the second set of options
    Then I should see "$24.99" in the price
      And the add to cart button should be enabled
   
  #Scenario: Should show variant images when a selection is made
  #  Given I have a product with variants and images
  #    And I'm on the product page for the first product
  #  When I follow "Small" within the first set of options
  #    And I follow "Green" within the second set of options
  #  Then the add to cart button should be enabled
  #    And I should see "Small Green" in the variant images label 
  #  When I follow "Red" within the second set of options
  #  Then I should see "Small Red" in the variant images label   
    