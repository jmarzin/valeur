Given /^the following projets:$/ do |projets|
  Projet.create!(projets.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) projet$/ do |pos|
  visit projets_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following projets:$/ do |expected_projets_table|
  expected_projets_table.diff!(tableish('table tr', 'td,th'))
end
