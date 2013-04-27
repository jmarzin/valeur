# encoding: utf-8

Quand(/^il n'y pas de projet$/) do
end

Alors(/^je ne vois pas Code,Nom,Ministère,Public,Etat,Date début,Montant,Retour,Delta coût,Delta retour,Quotation$/) do
  p page.text
  page.text.should_not =~ /Code/  
#	match(/Code\W+/)#Nom\W+Ministère\W+Public\W+Etat\W+Date début\W+Montant\W+Retour\W+Delta coût\W+Delta retour\W+Quotation/
end


Alors(/^je vois Code,Nom,Ministère,Public,Etat,Date début,Montant,Retour,Delta coût,Delta retour,Quotation$/) do
  page.text.should match(/Code\W+Nom\W+Ministère\W+Public\W+Etat\W+Date début\W+Montant\W+Retour\W+Delta coût\W+Delta retour\W+Quotation/)
end

Etantdonné(/^un projet complet dans la base$/) do
  resume1 = FactoryGirl.build(:resume, date: '01.01.2012', cout: 100.000, dr: 2.5)
  resume2 = FactoryGirl.build(:resume, date: '01.01.2013', cout: 150.264, dr: 3.0)
  FactoryGirl.create(:projet, code: "XXXX", nom: "Chorus", ministere: "Finances", etat: :lance, date_debut: '01.01.2012',
	resumes: [resume1,resume2], derive_cout: 50, derive_dr: 20, quotation_disic: 3)
end

Alors(/^je vois ses Code,Nom,Ministère,Public,Etat,Date début,Montant,Retour,Delta coût,Delta dr,Quotation$/) do
  page.text.should match(/XXXX\W+Chorus\W+Finances\W+Oui\W+Lance\W+2012-01-01\W+150\.3\W+3\.0\W+ 50 %\W+\+ 20 %\W+3/)
end

Etantdonné(/^que je suis sur la page de création d'un projet$/) do
  visit path_to("new_projet")
end

Etantdonné(/^que je saisis les donnees du formulaire$/) do
  fill_in('projet_code', :with => "XXXX")
  fill_in('projet_nom', :with => "Chorus")
  select('Finances', :from => 'Ministères')
  fill_in('projet_description', :with => "Description")
  fill_in('projet_entites_concernees', :with => "Entités")
end

Alors(/^le projet est créé$/) do
  page.should have_content "Le projet a été correctement créé"
end


Alors(/^je ne vois pas d'erreur$/) do
  page.should_not have_content "ce projet n'a pas pu être enregistré"
end

Alors(/^je me retrouve sur la page (.+)$/) do |page|
  current_path.to_s.should == page
end

Alors(/^je vois mon projet$/) do
  page.should have_content "Chorus"
end

Quand(/^je ne saisis rien dans la zone (.+)$/) do |zone|
  fill_in("projet_#{zone}", :with => "")
  click_button('Save')
end

Quand(/^je sélectionne "(.*?)" dans la zone (.+)$/) do |valeur,champ|
  select(valeur, :from => champ)
  click_button('Save')
end

Alors(/^je vois le message (.+)$/) do |message|
  page.should have_content message
end

Etantdonné(/^un projet sans étude dans la base$/) do
  FactoryGirl.create(:projet)
end

Alors(/^je vois un sélecteur d(?:e |')(.+)$/) do |selecteur|
  expect(page.has_select?(selecteur)).to eq(true)
end

Etantdonné(/^un projet sans étude dans l'état (.+)$/) do |etat|
  FactoryGirl.create(:projet,etat: etat.to_sym)
end

Etantdonné(/^un projet avec étude dans l'état (.+)$/) do |etat|
  resume = FactoryGirl.build(:resume)
  FactoryGirl.create(:projet,etat: etat.to_sym,resumes: [resume])
end

Alors(/^je vois cet état (.+ )comme option et les options (.+)$/) do |etat,options|
  expect(page.has_select?('Etat', :with_options => (etat+options).split)).to eq(true)
end

Alors(/^je vois cet état (.+) comme option et les options $/) do  |etat|
  page.has_select?('Etat', :with_options => [etat])
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
