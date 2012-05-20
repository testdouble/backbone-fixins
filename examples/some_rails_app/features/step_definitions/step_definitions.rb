Given /^I'm at the site's root page$/ do
  visit "/"
end

When /^I click "(.*?)"$/ do |locator|
  click_link locator
end

Then /^I should see "(.*?)"$/ do |text|
  page.should have_content text
end
