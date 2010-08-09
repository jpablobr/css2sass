Given /^I have a page object with "([^\"]*)" in the html attribute$/ do |html|
  @page = {:page => {:html => html}}
  
end

When /^I post the page object to \/json$/ do
  puts post("/json", :page_html => "Hello").body
end

Then /^I should see "([^\"]*)"<h1>Hello World<\/h1>"([^\"]*)"\\n%h1\\n  Hello World"([^\"]*)"$/ do |arg1, arg2, arg3|
  
end
