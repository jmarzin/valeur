# encoding: utf-8

Alors(/^je vois le tableau de répartition des cadres d'emplois$/) do
  page.should have_selector('article#cadre')
end

Alors(/^je vois le tableau des coûts indirects cumulés par nature$/) do
  page.should have_selector('article#somme_ind')
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
    find_field('indirect_details_attributes_0_description').value.should =~ /Ligne 1/
    page.has_select?('indirect_details_attributes_0_nature', :selected => 'Coûts MOA').should be true
    find_field('indirect_details_attributes_0_montants_attributes_1_montant').value.should == '1.0'
    find_field('indirect_details_attributes_0_montants_attributes_2_montant').value.should == '2.0'
    find_field('indirect_details_attributes_0_montants_attributes_3_montant').value.should == '3.0'
    page.should have_content('6.0')
  end
  within('tr#2') do
    find_field('indirect_details_attributes_1_description').value.should =~ /Ligne 2/
    page.has_select?('indirect_details_attributes_1_nature', :selected => 'Coûts MOA').should be true
    find_field('indirect_details_attributes_1_montants_attributes_1_montant').value.should == '4.0'
    find_field('indirect_details_attributes_1_montants_attributes_2_montant').value.should == '5.0'
    find_field('indirect_details_attributes_1_montants_attributes_3_montant').value.should == '6.0'
    find_field('indirect_details_attributes_1_montants_attributes_5_montant').value.should == '7.0'
    page.should have_content('22.0')
  end
  within('tr#3') do
    find_field('indirect_details_attributes_2_description').value.should =~ /Ligne 3/
    page.has_select?('indirect_details_attributes_2_nature', :selected => 'Coûts MOE').should be true
    find_field('indirect_details_attributes_2_montants_attributes_4_montant').value.should == '8.0'
    page.should have_content('8.0')
  end
  within('tr#4') do
    find_field('indirect_details_attributes_3_description').value.should =~ /Ligne 4/
    page.has_select?('indirect_details_attributes_3_nature', :selected => 'Formation:temps formateur').should be true
    find_field('indirect_details_attributes_3_montants_attributes_5_montant').value.should == '9.0'
    page.should have_content('9.0')
  end
  within('tr#5') do
    find_field('indirect_details_attributes_4_description').value.should =~ /Ligne 5/
    page.has_select?('indirect_details_attributes_4_nature', :selected => 'Formation:temps stagiaire').should be true
    find_field('indirect_details_attributes_4_montants_attributes_4_montant').value.should == '10.0'
    page.should have_content('10.0')
  end
  within('tr#6') do
    find_field('indirect_details_attributes_5_description').value.should =~ /Ligne 7/
    page.has_select?('indirect_details_attributes_5_nature', :selected => 'Autre').should be true
    find_field('indirect_details_attributes_5_montants_attributes_1_montant').value.should == '1000.0'
    find_field('indirect_details_attributes_5_montants_attributes_3_montant').value.should == '2000.0'
    find_field('indirect_details_attributes_5_montants_attributes_5_montant').value.should == '3000.0'
    page.should have_content('6 000.0')
  end
  page.text.should =~ %r{Coûts indirects en ETP ETP 55\.0 5\.0 7\.0 9\.0 18\.0 16\.0 Coût complet moyen du personnel k€/ETP 66\.5 67\.5 68\.5 \
69\.5 70\.5 Coûts indirects existant exprimés en ETP valorisés k€ 3 799\.8 332\.5 472\.2 616\.5 1 250\.3 1 128\.3 Coûts indirects k€ 6 000\.0 \
1 000\.0 2 000\.0 3 000\.0 Total des coûts indirects k€ 9 799\.8 1 332\.5 472\.2 2 616\.5 1 250\.3 4 128\.3 Coûts indirects pluriannuels Exprimés \
en Totaux Coûts MOA ETP 28\.0 Coûts MOE ETP 8\.0 Formation:temps formateur ETP 9\.0 Formation:temps stagiaire ETP 10\.0 Autre k€ 6 000\.0}
end

Quand(/^je saisis un commentaire sur les coûts indirects$/) do
  fill_in 'indirect_commentaires', :with => 'Un commentaire sur les coûts indirects' 
end

Alors(/^je vois le commentaire sur les coûts indirects$/) do
  page.text.should =~ /Un commentaire sur les coûts indirects/
end

