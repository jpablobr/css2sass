Feature: Convert Html 2 Haml
  In order to convert html 2 haml
  As a guest
  I want to copy a snippet of html into a text box and press covert to haml and display the haml in a results text area
  
  @working
  Scenario: Copy Html and Convert to Haml
    Given I go to /
    And I fill in "Html" with "<h1>Hello World</h1>"
    When I press "Convert"
    Then I should see "%h1"
    
  @working
  Scenario: Post Html via JSON and Convert to Haml
    Given I have a page object with "<h1>Hello World</h1>" in the html attribute
    When I post the page object to /json
    Then I should see "{page: { html: "<h1>Hello World</h1>", haml: "\n%h1\n  Hello World" }}"
    
  @current
  Scenario: Error with inserting TextArea in html
    Given I have a page object with "<textarea>Hello World</textarea><b>outside</b>" in the html attribute
    When I press "Convert"
    Then I should see "<textarea>Hello World</textarea><b>outside</b>"