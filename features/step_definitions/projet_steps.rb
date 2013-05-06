# encoding: utf-8

Quand(/^il n'y pas de projet$/) do
end

Alors(/^je ne vois pas Id,Code,Nom,Ministère,Public,Etat,Date début,Montant,Durée,Delta coût,Delta durée,Quotation$/) do
  page.text.should_not =~ /Code/  
end


Alors(/^je vois Id,Code,Nom,Ministère,Public,Etat,Date début,Montant,Durée,Delta coût,Delta durée,Quotation$/) do
  page.text.should match(/Id\W+Code\W+Nom\W+Ministère\W+Public\W+Etat\W+Date début\W+Montant\W+Durée\W+Delta coût\W+Delta durée\W+Quotation/)
end

Etantdonné(/^un projet complet dans la base$/) do
  resume1 = FactoryGirl.build(:resume, date: '01.01.2012', stade: :projet, cout: 100.000, duree: 2.5)
  resume2 = FactoryGirl.build(:resume, date: '01.01.2013', stade: :suivi01, cout: 150.264, duree: 3.0)
  FactoryGirl.create(:projet, code: "XXXX", nom: "Chorus", ministere: "Finances", etat: :en_cours, date_debut: '01.01.2012',
	resumes: [resume1,resume2], derive_cout: 50, derive_duree: 20, quotation_disic: 3)
end

Alors(/^je vois ses Id,Code,Nom,Ministère,Public,Etat,Date début,Montant,Durée,Delta coût,Delta durée,Quotation$/) do
  page.text.should match(/1\W+XXXX\W+Chorus\W+Finances\W+Oui\W+En_cours\W+2012-01-01\W+150\.3\W+3\.0\W+ 50 %\W+\+ 20 %\W+3/)
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
  page.should have_content "Le projet a été créé"
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

Quand(/^(?:que je|je) ne saisis rien dans la zone (.+)$/) do |zone|
  fill_in(zone, :with => "")
  click_button('Enregistrer')
end

Quand(/^(?:que je|je) sélectionne "(.*?)" dans la zone (.+)$/) do |valeur,champ|
  select(valeur, :from => champ)
  click_button('Enregistrer')
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
  @projet = FactoryGirl.create(:projet,etat: etat.to_sym, date_debut: '2013.01.01', resumes: [resume])
end

Alors(/^je vois cet état (.+ )comme option et les options (.+)$/) do |etat,options|
  expect(page.has_select?('Etat', :with_options => (etat+options).split)).to eq(true)
end

Alors(/^je ne vois pas les options (.+)/) do |options|
  options.split.each { |op| expect(page.has_select?('Etat', :with_options => [op])).to eq(false) }
end

Alors(/^je vois cet état (.+) comme option et les options $/) do  |etat|
  expect(page.has_select?('Etat', :with_options => [etat])).to eq(true)
end

Alors(/^je vois l'option (.+)$/) do  |etat|
  expect(page.has_select?('Etat', :with_options => [etat])).to eq(true)
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

Alors(/^je ne vois pas l'option (.+)$/) do |option|
  expect(page.has_select?('Etat', :with_options => [option])).to eq(false)
end

Alors(/^je vois son historique$/) do
  visit('projets/1')
  page.should have_content /Historique.+projet.+suivi01/
  expect(page.has_link?('Toutes les études')).to eq(true)
end

Etantdonnés(/^des projets des différents états dans la base$/) do
  resume = FactoryGirl.build(:resume, date: '01.01.2013', stade: :avant_projet, cout: 150.264, duree: 3.0)
  projet = FactoryGirl.create(:projet, code: "XXXX", nom: "Chorus1", ministere: "Finances", etat: :a_l_etude, date_debut: '01.01.2012',
	resumes: [resume], quotation_disic: 3)
  projet.etudes.push\
    (FactoryGirl.build(:etude, projet_id: projet._id,code: 'XXXX',stade: :avant_projet,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 ))

  resume = FactoryGirl.build(:resume, date: '01.01.2013', stade: :projet, cout: 150.264, duree: 3.0)
  projet = FactoryGirl.create(:projet, code: "YYYY", nom: "Chorus2", ministere: "Finances", etat: :soumis, date_debut: '01.01.2012',
	resumes: [resume], quotation_disic: 3)
  projet.etudes.push\
    (FactoryGirl.build(:etude, projet_id: projet._id,code: 'YYYY',stade: :projet,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 ))

  resume = FactoryGirl.build(:resume, date: '01.01.2013', stade: :projet, cout: 150.264, duree: 3.0)
  projet = FactoryGirl.create(:projet, code: "ZZZZ", nom: "Chorus3", ministere: "Finances", etat: :accepte, date_debut: '01.01.2012',
	resumes: [resume], quotation_disic: 3)
  projet.etudes.push\
    (FactoryGirl.build(:etude, projet_id: projet._id,code: 'ZZZZ',stade: :projet,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 ))

  resume = FactoryGirl.build(:resume, date: '01.01.2013', stade: :projet, cout: 150.264, duree: 3.0)
  projet = FactoryGirl.create(:projet, code: "AAAA", nom: "Chorus4", ministere: "Finances", etat: :refuse, date_debut: '01.01.2012',
	resumes: [resume], quotation_disic: 3)
  projet.etudes.push\
    (FactoryGirl.build(:etude, projet_id: projet._id,code: 'AAAA',stade: :projet,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 ))

  resume = FactoryGirl.build(:resume, date: '01.01.2013', stade: :projet, cout: 150.264, duree: 3.0)
  projet = FactoryGirl.create(:projet, code: "BBBB", nom: "Chorus5", ministere: "Finances", etat: :en_cours, date_debut: '01.01.2012',
	resumes: [resume], quotation_disic: 3)
  projet.etudes.push\
    (FactoryGirl.build(:etude, projet_id: projet._id,code: 'BBBB',stade: :projet,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 ))

  resume = FactoryGirl.build(:resume, date: '01.01.2013', stade: :projet, cout: 150.264, duree: 3.0)
  projet = FactoryGirl.create(:projet, code: "CCCC", nom: "Chorus6", ministere: "Finances", etat: :arrete, date_debut: '01.01.2012',
	resumes: [resume], quotation_disic: 3)
  projet.etudes.push\
    (FactoryGirl.build(:etude, projet_id: projet._id,code: 'CCCC',stade: :projet,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 ))

  resume = FactoryGirl.build(:resume, date: '01.01.2013', stade: :projet, cout: 150.264, duree: 3.0)
  projet = FactoryGirl.create(:projet, code: "DDDD", nom: "Chorus7", ministere: "Finances", etat: :termine, date_debut: '01.01.2012',
	resumes: [resume], quotation_disic: 3)
  projet.etudes.push\
    (FactoryGirl.build(:etude, projet_id: projet._id,code: 'DDDD',stade: :projet,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 ))

  resume = FactoryGirl.build(:resume, date: '01.01.2013', stade: :projet, cout: 150.264, duree: 3.0)
  projet = FactoryGirl.create(:projet, code: "EEEE", nom: "Chorus8", ministere: "Finances", etat: :abandonne, date_debut: '01.01.2012',
	resumes: [resume], quotation_disic: 3)
  projet.etudes.push\
    (FactoryGirl.build(:etude, projet_id: projet._id,code: 'EEEE',stade: :projet,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 ))
end

Alors(/^je vois le lien (.+) pour le projet Abandonné$/) do |lien|
  visit('/projets')
  reg = Regexp.new(lien)
  page.all('tr',:text => 'Abandonne').first.text.should =~ reg
end

Alors(/^je ne vois pas le lien Supp pour les autres$/) do
  page.all('tr',:text => 'A_l_etude').first.text.should_not =~ /Supp/
  page.all('tr',:text => 'Soumis').first.text.should_not =~ /Supp/
  page.all('tr',:text => 'Accepte').first.text.should_not =~ /Supp/
  page.all('tr',:text => 'Refuse').first.text.should_not =~ /Supp/
  page.all('tr',:text => 'En_cours').first.text.should_not =~ /Supp/
  page.all('tr',:text => 'Termine').first.text.should_not =~ /Supp/
  page.all('tr',:text => 'Arrete').first.text.should_not =~ /Supp/
end

Alors(/^je ne vois pas le lien Modif pour les projets Abandonné, Terminé, Arrêté$/) do
  visit('/projets')
  page.all('tr',:text => 'Abandonne').first.text.should_not =~ /Modif/
  page.all('tr',:text => 'Termine').first.text.should_not =~ /Modif/
  page.all('tr',:text => 'Arrete').first.text.should_not =~ /Modif/
end

Alors(/^je vois le lien Modif pour les autres$/) do
  page.all('tr',:text => 'A_l_etude').first.text.should =~ /Modif/
  page.all('tr',:text => 'Soumis').first.text.should =~ /Modif/
  page.all('tr',:text => 'Accepte').first.text.should =~ /Modif/
  page.all('tr',:text => 'Refuse').first.text.should =~ /Modif/
  page.all('tr',:text => 'En_cours').first.text.should =~ /Modif/
end

Alors(/^la date début ne peut pas être modifiée pour les projets en_cours, arrêtés, terminés$/) do
  visit('/projets/5/edit')
  expect(find_by_id("projet_date_debut_1i").disabled?).to eq("disabled")
  visit('/projets/6/edit')
  expect(find_by_id("projet_date_debut_1i").disabled?).to eq("disabled")
  visit('/projets/7/edit')
  expect(find_by_id("projet_date_debut_1i").disabled?).to eq("disabled")
end
