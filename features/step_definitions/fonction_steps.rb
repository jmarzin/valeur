# encoding: utf-8

Alors(/^je vois deux tableaux de répartition des cadres d'emplois$/) do
  page.has_css?('table#cadre', :count => 2).should be true
end

Alors(/^je vois deux tableaux des impacts détaillés$/) do
  page.has_css?('table#detail', :count => 2).should be true
end

Quand(/^je saisis (\d+) pour les cadres A et (\d+) pour les cadres B dans la situation actuelle$/) do |arg1, arg2|
  fill_in 'fonction_situations_attributes_0_repartitions_attributes_1_pourcent', :with => arg1
  fill_in 'fonction_situations_attributes_0_repartitions_attributes_2_pourcent', :with => arg2
end

Quand(/^je saisis (\d+) pour les cadres A et (\d+) pour les cadres B dans la situation cible$/) do |arg1, arg2|
  fill_in 'fonction_situations_attributes_1_repartitions_attributes_1_pourcent', :with => arg1
  fill_in 'fonction_situations_attributes_1_repartitions_attributes_2_pourcent', :with => arg2
end

Quand(/^je remplis le tableau des impacts sur les coûts de fonctionnement$/) do
  within('article#actuelle') do
    within('tr#1') do
      fill_in 'fonction_situations_attributes_0_details_attributes_0_description', :with => 'Ligne 1'
      select('Coûts de personnel', :from => 'fonction_situations_attributes_0_details_attributes_0_nature')
      fill_in 'fonction_situations_attributes_0_details_attributes_0_montants_attributes_0_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_0_montants_attributes_1_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_0_montants_attributes_2_montant', :with => '2'
      click_button('Insv')
      click_button('Insv')
    end
  end
  within('article#actuelle') do
    within('tr#3') do
      click_button('Sup')
    end
  end
  within('article#actuelle') do
    within('tr#2') do
      fill_in 'fonction_situations_attributes_0_details_attributes_1_description', :with => 'Ligne 2'
      select('Maintenance matériel et infrastructure', :from => 'fonction_situations_attributes_0_details_attributes_1_nature')
      fill_in 'fonction_situations_attributes_0_details_attributes_1_montants_attributes_1_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_1_montants_attributes_2_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_1_montants_attributes_3_montant', :with => '2'
      click_button('Insv')
    end
  end
  within('article#actuelle') do
    within('tr#3') do
      fill_in 'fonction_situations_attributes_0_details_attributes_2_description', :with => 'Ligne 3'
      select('Maintenance application', :from => 'fonction_situations_attributes_0_details_attributes_2_nature')
      fill_in 'fonction_situations_attributes_0_details_attributes_2_montants_attributes_2_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_2_montants_attributes_3_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_2_montants_attributes_4_montant', :with => '2'
      click_button('Insv')
    end
  end
  within('article#actuelle') do
    within('tr#4') do
      fill_in 'fonction_situations_attributes_0_details_attributes_3_description', :with => 'Ligne 4'
      select('Externalisations', :from => 'fonction_situations_attributes_0_details_attributes_3_nature')
      fill_in 'fonction_situations_attributes_0_details_attributes_3_montants_attributes_3_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_3_montants_attributes_4_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_3_montants_attributes_5_montant', :with => '2'
      click_button('Insv')
    end
  end
  within('article#actuelle') do
    within('tr#5') do
      fill_in 'fonction_situations_attributes_0_details_attributes_4_description', :with => 'Ligne 5'
      select('Abonnements', :from => 'fonction_situations_attributes_0_details_attributes_4_nature')
      fill_in 'fonction_situations_attributes_0_details_attributes_4_montants_attributes_4_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_4_montants_attributes_5_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_4_montants_attributes_6_montant', :with => '2'
      click_button('Insv')
    end
  end
  within('article#actuelle') do
    within('tr#6') do
      fill_in 'fonction_situations_attributes_0_details_attributes_5_description', :with => 'Ligne 6'
      select('Autres', :from => 'fonction_situations_attributes_0_details_attributes_5_nature')
      fill_in 'fonction_situations_attributes_0_details_attributes_5_montants_attributes_5_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_5_montants_attributes_6_montant', :with => '2'
      fill_in 'fonction_situations_attributes_0_details_attributes_5_montants_attributes_7_montant', :with => '2'
    end
  end
  within('article#cible') do
    within('tr#1') do
      fill_in 'fonction_situations_attributes_1_details_attributes_0_description', :with => 'Ligne 7'
      select('Coûts de personnel', :from => 'fonction_situations_attributes_1_details_attributes_0_nature')
      fill_in 'fonction_situations_attributes_1_details_attributes_0_montants_attributes_0_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_0_montants_attributes_1_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_0_montants_attributes_2_montant', :with => '1'
      click_button('Insv')
      click_button('Insv')
    end
  end
  within('article#cible') do
    within('tr#3') do
      click_button('Sup')
    end
  end
  within('article#cible') do
    within('tr#2') do
      fill_in 'fonction_situations_attributes_1_details_attributes_1_description', :with => 'Ligne 8'
      select('Maintenance matériel et infrastructure', :from => 'fonction_situations_attributes_1_details_attributes_1_nature')
      fill_in 'fonction_situations_attributes_1_details_attributes_1_montants_attributes_1_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_1_montants_attributes_2_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_1_montants_attributes_3_montant', :with => '1'
      click_button('Insv')
    end
  end
  within('article#cible') do
    within('tr#3') do
      fill_in 'fonction_situations_attributes_1_details_attributes_2_description', :with => 'Ligne 9'
      select('Maintenance application', :from => 'fonction_situations_attributes_1_details_attributes_2_nature')
      fill_in 'fonction_situations_attributes_1_details_attributes_2_montants_attributes_2_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_2_montants_attributes_3_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_2_montants_attributes_4_montant', :with => '1'
      click_button('Insv')
    end
  end
  within('article#cible') do
    within('tr#4') do
      fill_in 'fonction_situations_attributes_1_details_attributes_3_description', :with => 'Ligne 10'
      select('Externalisations', :from => 'fonction_situations_attributes_1_details_attributes_3_nature')
      fill_in 'fonction_situations_attributes_1_details_attributes_3_montants_attributes_3_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_3_montants_attributes_4_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_3_montants_attributes_5_montant', :with => '1'
      click_button('Insv')
    end
  end
  within('article#cible') do
    within('tr#5') do
      fill_in 'fonction_situations_attributes_1_details_attributes_4_description', :with => 'Ligne 11'
      select('Abonnements', :from => 'fonction_situations_attributes_1_details_attributes_4_nature')
      fill_in 'fonction_situations_attributes_1_details_attributes_4_montants_attributes_4_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_4_montants_attributes_5_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_4_montants_attributes_6_montant', :with => '1'
      click_button('Insv')
    end
  end
  within('article#cible') do
    within('tr#6') do
      fill_in 'fonction_situations_attributes_1_details_attributes_5_description', :with => 'Ligne 12'
      select('Autres', :from => 'fonction_situations_attributes_1_details_attributes_5_nature')
      fill_in 'fonction_situations_attributes_1_details_attributes_5_montants_attributes_5_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_5_montants_attributes_6_montant', :with => '1'
      fill_in 'fonction_situations_attributes_1_details_attributes_5_montants_attributes_7_montant', :with => '1'
    end
  end
end

Alors(/^je vois les cumuls impacts calculés$/) do
  within('article#actuelle') do
    within('tr#1') do
      find_field('fonction_situations_attributes_0_details_attributes_0_description').value.should == 'Ligne 1'
      page.has_select?('fonction_situations_attributes_0_details_attributes_0_nature', :selected => 'Coûts de personnel').should be true
      find_field('fonction_situations_attributes_0_details_attributes_0_montants_attributes_0_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_0_montants_attributes_1_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_0_montants_attributes_2_montant').value.should == '2'
      page.should have_content('6')
    end
  end
  within('article#actuelle') do
    within('tr#2') do
      find_field('fonction_situations_attributes_0_details_attributes_1_description').value.should == 'Ligne 2'
      page.has_select?('fonction_situations_attributes_0_details_attributes_1_nature', :selected => 'Maintenance matériel et infrastructure').should be true
      find_field('fonction_situations_attributes_0_details_attributes_1_montants_attributes_1_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_1_montants_attributes_2_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_1_montants_attributes_3_montant').value.should == '2'
      page.should have_content('6')
    end
  end
  within('article#actuelle') do
    within('tr#3') do
      find_field('fonction_situations_attributes_0_details_attributes_2_description').value.should == 'Ligne 3'
      page.has_select?('fonction_situations_attributes_0_details_attributes_2_nature', :selected => 'Maintenance application').should be true
      find_field('fonction_situations_attributes_0_details_attributes_2_montants_attributes_2_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_2_montants_attributes_3_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_2_montants_attributes_4_montant').value.should == '2'
      page.should have_content('6')
    end
  end
  within('article#actuelle') do
    within('tr#4') do
      find_field('fonction_situations_attributes_0_details_attributes_3_description').value.should == 'Ligne 4'
      page.has_select?('fonction_situations_attributes_0_details_attributes_3_nature', :selected => 'Externalisations').should be true
      find_field('fonction_situations_attributes_0_details_attributes_3_montants_attributes_3_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_3_montants_attributes_4_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_3_montants_attributes_5_montant').value.should == '2'
      page.should have_content('6')
    end
  end
  within('article#actuelle') do
    within('tr#5') do
      find_field('fonction_situations_attributes_0_details_attributes_4_description').value.should == 'Ligne 5'
      page.has_select?('fonction_situations_attributes_0_details_attributes_4_nature', :selected => 'Abonnements').should be true
      find_field('fonction_situations_attributes_0_details_attributes_4_montants_attributes_4_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_4_montants_attributes_5_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_4_montants_attributes_6_montant').value.should == '2'
      page.should have_content('6')
    end
  end
  within('article#actuelle') do
    within('tr#6') do
      find_field('fonction_situations_attributes_0_details_attributes_5_description').value.should == 'Ligne 6'
      page.has_select?('fonction_situations_attributes_0_details_attributes_5_nature', :selected => 'Autres').should be true
      find_field('fonction_situations_attributes_0_details_attributes_5_montants_attributes_5_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_5_montants_attributes_6_montant').value.should == '2'
      find_field('fonction_situations_attributes_0_details_attributes_5_montants_attributes_7_montant').value.should == '2'
      page.should have_content('6')
    end
  end
  within('article#cible') do
    within('tr#1') do
      find_field('fonction_situations_attributes_1_details_attributes_0_description').value.should == 'Ligne 7'
      page.has_select?('fonction_situations_attributes_1_details_attributes_0_nature', :selected => 'Coûts de personnel').should be true
      find_field('fonction_situations_attributes_1_details_attributes_0_montants_attributes_0_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_0_montants_attributes_1_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_0_montants_attributes_2_montant').value.should == '1'
      page.should have_content('3')
    end
  end
  within('article#cible') do
    within('tr#2') do
      find_field('fonction_situations_attributes_1_details_attributes_1_description').value.should == 'Ligne 8'
      page.has_select?('fonction_situations_attributes_1_details_attributes_1_nature', :selected => 'Maintenance matériel et infrastructure').should be true
      find_field('fonction_situations_attributes_1_details_attributes_1_montants_attributes_1_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_1_montants_attributes_2_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_1_montants_attributes_3_montant').value.should == '1'
      page.should have_content('3')
    end
  end
  within('article#cible') do
    within('tr#3') do
      find_field('fonction_situations_attributes_1_details_attributes_2_description').value.should == 'Ligne 9'
      page.has_select?('fonction_situations_attributes_1_details_attributes_2_nature', :selected => 'Maintenance application').should be true
      find_field('fonction_situations_attributes_1_details_attributes_2_montants_attributes_2_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_2_montants_attributes_3_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_2_montants_attributes_4_montant').value.should == '1'
      page.should have_content('3')
    end
  end
  within('article#cible') do
    within('tr#4') do
      find_field('fonction_situations_attributes_1_details_attributes_3_description').value.should == 'Ligne 10'
      page.has_select?('fonction_situations_attributes_1_details_attributes_3_nature', :selected => 'Externalisations').should be true
      find_field('fonction_situations_attributes_1_details_attributes_3_montants_attributes_3_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_3_montants_attributes_4_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_3_montants_attributes_5_montant').value.should == '1'
      page.should have_content('3')
    end
  end
  within('article#cible') do
    within('tr#5') do
      find_field('fonction_situations_attributes_1_details_attributes_4_description').value.should == 'Ligne 11'
      page.has_select?('fonction_situations_attributes_1_details_attributes_4_nature', :selected => 'Abonnements').should be true
      find_field('fonction_situations_attributes_1_details_attributes_4_montants_attributes_4_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_4_montants_attributes_5_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_4_montants_attributes_6_montant').value.should == '1'
      page.should have_content('3')
    end
  end
  within('article#cible') do
    within('tr#6') do
      find_field('fonction_situations_attributes_1_details_attributes_5_description').value.should == 'Ligne 12'
      page.has_select?('fonction_situations_attributes_1_details_attributes_5_nature', :selected => 'Autres').should be true
      find_field('fonction_situations_attributes_1_details_attributes_5_montants_attributes_5_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_5_montants_attributes_6_montant').value.should == '1'
      find_field('fonction_situations_attributes_1_details_attributes_5_montants_attributes_7_montant').value.should == '1'
      page.should have_content('3')
    end
  end
  within('article#actuelle') do
    page.text.should =~ %r{Coûts indirects exprimés en ETP ETP 6 2 2 2 Coût complet moyen du personnel k€/ETP 65.5 65.5 66.5 \
Coûts indirects exprimés en ETP valorisés k€ 395 131 131 133 Coûts indirects exprimés en k€ k€ 30 2 4 6 6 6 4 2 TOTAL COÛTS \
INDIRECTS k€ 425 131 133 137 6 6 6 4 2}
  end
  within('article#cible') do
    page.text.should =~ %r{Coûts indirects exprimés en ETP ETP 3 1 1 1 Coût complet moyen du personnel k€/ETP 65.5 65.5 66.5 \
Coûts indirects exprimés en ETP valorisés k€ 198 66 66 67 Coûts indirects exprimés en k€ k€ 15 1 2 3 3 3 2 1 TOTAL COÛTS \
INDIRECTS k€ 213 66 67 69 3 3 3 2 1 IMPACTS SUR LES COÛTS DE FONCTIONNEMENT SI k€ -213 -66 -67 -69 -3 -3 -3 -2 -1}
  end
end

Quand(/^je saisis un commentaire pour la situation (.+)$/) do |situation|
  if situation == 'actuelle' then indice = '0' else indice = '1' end
  within("article##{situation}") do
    fill_in "fonction_situations_attributes_#{indice}_commentaires", :with => "Commentaire pour la situation #{situation}"
  end
end

Alors(/^je vois les commentaires au bon endroit$/) do
  within('article#actuelle') do
    page.text.should =~ /Commentaire pour la situation actuelle/
  end
  within('article#cible') do
    page.text.should =~ /Commentaire pour la situation cible/
  end
end
