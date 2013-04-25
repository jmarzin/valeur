# encoding: utf-8


Alors(/^je vois Code, Nom, Ministère, Public, Etat, Date début, Montant, Delta coût, Delta dr, Quotation$/) do
  page.text.should match(/Code\W+Nom\W+Ministère\W+Public\W+Etat\W+Date début\W+Montant\W+Delta coût\W+Delta retour\W+Quotation/)
end

Etantdonné(/^les projets suivants:$/) do |table|
  # table is a Cucumber::Ast::Table
  p table
  pending # express the regexp above with the code you wish you had
end


Etantdonné /^I delete the (\d+)(?:st|nd|rd|th) projet$/ do |pos|
  visit projets_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Alors /^I should see the following projets:$/ do |expected_projets_table|
  expected_projets_table.diff!(tableish('table tr', 'td,th'))
end
