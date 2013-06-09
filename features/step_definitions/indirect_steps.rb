# encoding: utf-8

Alors(/^je vois le tableau de répartition des cadres d'emplois$/) do
  page.should have_selector('article#cadre')
end

Quand(/^je saisis (\d+) pour les cadres A et (\d+) pour les cadres B$/) do |arg1, arg2|
  fill_in 'indirect_repartitions_attributes_1_pourcent', :with => arg1
  fill_in 'indirect_repartitions_attributes_2_pourcent', :with => arg2
end

Quand(/^je remplis le tableau des coûts indirects détaillés$/) do
  within('tr#1') do
    fill_in 'indirect_details_attributes_0_description', :with => 'Ligne 1'
    select('Coûts MOA', :from => 'indirect_details_attributes_0_nature')
    fill_in 'indirect_details_attributes_0_montants_attributes_1_montant', :with => '1'
    fill_in 'indirect_details_attributes_0_montants_attributes_2_montant', :with => '2'
    fill_in 'indirect_details_attributes_0_montants_attributes_3_montant', :with => '3'
    click_button('Insv')
  end
  within('tr#2') do
    fill_in 'indirect_details_attributes_1_description', :with => 'Ligne 2'
    select('Coûts MOA', :from => 'indirect_details_attributes_1_nature')
    fill_in 'indirect_details_attributes_1_montants_attributes_1_montant', :with => '4'
    fill_in 'indirect_details_attributes_1_montants_attributes_2_montant', :with => '5'
    fill_in 'indirect_details_attributes_1_montants_attributes_3_montant', :with => '6'
    fill_in 'indirect_details_attributes_1_montants_attributes_5_montant', :with => '7'
    click_button('Insv')
  end  
  within('tr#3') do
    fill_in 'indirect_details_attributes_2_description', :with => 'Ligne 3'
    select('Coûts MOE', :from => 'indirect_details_attributes_2_nature')
    fill_in 'indirect_details_attributes_2_montants_attributes_4_montant', :with => '8'
    click_button('Insv')
  end
  within('tr#4') do
    fill_in 'indirect_details_attributes_3_description', :with => 'Ligne 4'
    select('Formation:temps formateur', :from => 'indirect_details_attributes_3_nature')
    fill_in 'indirect_details_attributes_3_montants_attributes_5_montant', :with => '9'
    click_button('Insv')
  end
  within('tr#5') do
    fill_in 'indirect_details_attributes_4_description', :with => 'Ligne 5'
    select('Formation:temps stagiaire', :from => 'indirect_details_attributes_4_nature')
    fill_in 'indirect_details_attributes_4_montants_attributes_4_montant', :with => '10'
    click_button('Insv')
    click_button('Insv')
    click_button('Insv')
  end
  within('tr#6') do
    click_button('Sup')
  end
  within('tr#7') do
    fill_in 'indirect_details_attributes_6_description', :with => 'Ligne 7'
    select('Autre', :from => 'indirect_details_attributes_6_nature')
    fill_in 'indirect_details_attributes_6_montants_attributes_1_montant', :with => '1000'
    fill_in 'indirect_details_attributes_6_montants_attributes_3_montant', :with => '2000'
    fill_in 'indirect_details_attributes_6_montants_attributes_5_montant', :with => '3000'
  end
end

Alors(/^je vois les cumuls indirects calculés$/) do
  within('tr#1') do
    find_field('indirect_details_attributes_0_description').value.should == 'Ligne 1'
    page.has_select?('indirect_details_attributes_0_nature', :selected => 'Coûts MOA').should be true
    find_field('indirect_details_attributes_0_montants_attributes_1_montant').value.should == '1'
    find_field('indirect_details_attributes_0_montants_attributes_2_montant').value.should == '2'
    find_field('indirect_details_attributes_0_montants_attributes_3_montant').value.should == '3'
    page.should have_content('6')
  end
  within('tr#2') do
    find_field('indirect_details_attributes_1_description').value.should == 'Ligne 2'
    page.has_select?('indirect_details_attributes_1_nature', :selected => 'Coûts MOA').should be true
    find_field('indirect_details_attributes_1_montants_attributes_1_montant').value.should == '4'
    find_field('indirect_details_attributes_1_montants_attributes_2_montant').value.should == '5'
    find_field('indirect_details_attributes_1_montants_attributes_3_montant').value.should == '6'
    find_field('indirect_details_attributes_1_montants_attributes_5_montant').value.should == '7'
    page.should have_content('22')
  end
  within('tr#3') do
    find_field('indirect_details_attributes_2_description').value.should == 'Ligne 3'
    page.has_select?('indirect_details_attributes_2_nature', :selected => 'Coûts MOE').should be true
    find_field('indirect_details_attributes_2_montants_attributes_4_montant').value.should == '8'
    page.should have_content('8')
  end
  within('tr#4') do
    find_field('indirect_details_attributes_3_description').value.should == 'Ligne 4'
    page.has_select?('indirect_details_attributes_3_nature', :selected => 'Formation:temps formateur').should be true
    find_field('indirect_details_attributes_3_montants_attributes_5_montant').value.should == '9'
    page.should have_content('9')
  end
  within('tr#5') do
    find_field('indirect_details_attributes_4_description').value.should == 'Ligne 5'
    page.has_select?('indirect_details_attributes_4_nature', :selected => 'Formation:temps stagiaire').should be true
    find_field('indirect_details_attributes_4_montants_attributes_4_montant').value.should == '10'
    page.should have_content('10')
  end
  within('tr#6') do
    find_field('indirect_details_attributes_5_description').value.should == 'Ligne 7'
    page.has_select?('indirect_details_attributes_5_nature', :selected => 'Autre').should be true
    find_field('indirect_details_attributes_5_montants_attributes_1_montant').value.should == '1000'
    find_field('indirect_details_attributes_5_montants_attributes_3_montant').value.should == '2000'
    find_field('indirect_details_attributes_5_montants_attributes_5_montant').value.should == '3000'
    page.should have_content('6 000')
  end
  page.text.should =~ %r{Coûts indirects en ETP ETP 55 5 7 9 18 16 Coût complet moyen du personnel k€\/ETP \
65.5 66.5 67.5 68.5 69.5 Coûts indirects existant exprimés en ETP valorisés k€\
 3 745 328 466 607 1 233 1 111 Coûts indirects k€ 6 000 1 000 2 000 3 000 Total des coûts indirects k€\
 9 745 1 328 466 2 607 1 233 4 111}
  page.text.should =~ /Coûts MOA ETP 28 Coûts MOE ETP 8 Formation:temps formateur ETP 9 Formation:temps stagiaire ETP 10 Autre k€ 6 000/
end

Quand(/^je saisis un commentaire pour la formation:temps formateur$/) do
  fill_in 'indirect_sommes_attributes_2_commentaire', :with => 'Un commentaire sur la formation:temps formateur' 
end

Alors(/^je vois le commentaire au bon endroit formation:temps formateur$/) do
  page.text.should =~ /Formation:temps formateur ETP 9 Un commentaire sur la formation:temps formateur Formation:temps stagiaire/
end

