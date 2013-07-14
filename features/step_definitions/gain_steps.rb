# encoding: utf-8

Quand(/^je saisis (\d+) pour les cadres A et (\d+) pour les cadres B pour ETP(\d+)$/) do |arg1, arg2, arg3|
  fill_in 'gain_etp_reparts_attributes_0_repartitions_attributes_1_pourcent', :with => arg1
  fill_in 'gain_etp_reparts_attributes_0_repartitions_attributes_2_pourcent', :with => arg2
end

Quand(/^je saisis (\d+) pour les cadres A\+ pour ETP(\d+)$/) do |arg1, arg2|
  fill_in 'gain_etp_reparts_attributes_4_repartitions_attributes_0_pourcent', :with => arg1
end

Quand(/^je remplis le tableau des gains métier$/) do
  within('tr#1') do
    fill_in 'gain_details_attributes_0_description', :with => 'Description 1'
    select('Augmentation des recettes', :from => 'gain_details_attributes_0_nature')
    select('ETP1', :from => 'gain_details_attributes_0_unite')
    fill_in 'gain_details_attributes_0_montants_attributes_0_montant', :with => '1'
    fill_in 'gain_details_attributes_0_montants_attributes_1_montant', :with => '2'
    click_button('Insv')
    click_button('Insv')
  end
  within('tr#3') do
    click_button('Sup')
  end
  within('tr#2') do
    fill_in 'gain_details_attributes_1_description', :with => 'Description 2'
    select('Economies induites', :from => 'gain_details_attributes_1_nature')
    select('ETP2', :from => 'gain_details_attributes_1_unite')
    fill_in 'gain_details_attributes_1_montants_attributes_1_montant', :with => '3'
    fill_in 'gain_details_attributes_1_montants_attributes_2_montant', :with => '4'
    click_button('Insv')
  end
  within('tr#3') do
    fill_in 'gain_details_attributes_2_description', :with => 'Description 3'
    select('Charge de travail', :from => 'gain_details_attributes_2_nature')
    select('ETP3', :from => 'gain_details_attributes_2_unite')
    fill_in 'gain_details_attributes_2_montants_attributes_2_montant', :with => '5'
    fill_in 'gain_details_attributes_2_montants_attributes_3_montant', :with => '6'
    click_button('Insv')
  end
  within('tr#4') do
    fill_in 'gain_details_attributes_3_description', :with => 'Description 4'
    select('Dépenses additionnelles', :from => 'gain_details_attributes_3_nature')
    select('ETP3', :from => 'gain_details_attributes_3_unite')
    fill_in 'gain_details_attributes_3_montants_attributes_3_montant', :with => '7'
    fill_in 'gain_details_attributes_3_montants_attributes_4_montant', :with => '8'
    click_button('Insv')
  end
  within('tr#5') do
    fill_in 'gain_details_attributes_4_description', :with => 'Description 5'
    select('Gain trésorerie', :from => 'gain_details_attributes_4_nature')
    select('ETP5', :from => 'gain_details_attributes_4_unite')
    fill_in 'gain_details_attributes_4_montants_attributes_4_montant', :with => '9'
    fill_in 'gain_details_attributes_4_montants_attributes_5_montant', :with => '10'
    click_button('Insv')
  end
  within('tr#6') do
    fill_in 'gain_details_attributes_5_description', :with => 'Description 6'
    select('Gain efficacité', :from => 'gain_details_attributes_5_nature')
    select('k€', :from => 'gain_details_attributes_5_unite')
    fill_in 'gain_details_attributes_5_montants_attributes_5_montant', :with => '1000'
    fill_in 'gain_details_attributes_5_montants_attributes_6_montant', :with => '2000'
    click_button('Insv')
  end
  within('tr#7') do
    fill_in 'gain_details_attributes_6_description', :with => 'Description 7'
    select('Gain productivité', :from => 'gain_details_attributes_6_nature')
    select('k€', :from => 'gain_details_attributes_6_unite')
    fill_in 'gain_details_attributes_6_montants_attributes_6_montant', :with => '3000'
    fill_in 'gain_details_attributes_6_montants_attributes_7_montant', :with => '4000'
    click_button('Insv')
  end
  within('tr#8') do
    fill_in 'gain_details_attributes_7_description', :with => 'Description 8'
    select('Autres gains', :from => 'gain_details_attributes_7_nature')
    select('k€', :from => 'gain_details_attributes_7_unite')
    fill_in 'gain_details_attributes_7_montants_attributes_7_montant', :with => '5000'
    fill_in 'gain_details_attributes_7_montants_attributes_8_montant', :with => '6000'
    click_button('Insv')
  end
  within('tr#9') do
    fill_in 'gain_details_attributes_8_description', :with => 'Description 9'
    select('Autres gains', :from => 'gain_details_attributes_8_nature')
    select('ETP1', :from => 'gain_details_attributes_8_unite')
    fill_in 'gain_details_attributes_8_montants_attributes_8_montant', :with => '11'
    fill_in 'gain_details_attributes_8_montants_attributes_9_montant', :with => '12'
  end
end

Alors(/^je vois les cumuls gains calculés$/) do
  within('tr#1') do
    find_field('gain_details_attributes_0_description').value.should =~ /Description 1/
    page.has_select?('gain_details_attributes_0_nature', :selected => 'Augmentation des recettes').should be true
    page.has_select?('gain_details_attributes_0_unite', :selected => 'ETP1').should be true
    find_field('gain_details_attributes_0_montants_attributes_0_montant').value.should == '1.0'
    find_field('gain_details_attributes_0_montants_attributes_1_montant').value.should == '2.0'
    page.should have_content('3.0')
  end
  within('tr#2') do
    find_field('gain_details_attributes_1_description').value.should =~ /Description 2/
    page.has_select?('gain_details_attributes_1_nature', :selected => 'Economies induites').should be true
    page.has_select?('gain_details_attributes_1_unite', :selected => 'ETP2').should be true
    find_field('gain_details_attributes_1_montants_attributes_1_montant').value.should == '3.0'
    find_field('gain_details_attributes_1_montants_attributes_2_montant').value.should == '4.0'
    page.should have_content('7.0')
  end
  within('tr#3') do
    find_field('gain_details_attributes_2_description').value.should =~ /Description 3/
    page.has_select?('gain_details_attributes_2_nature', :selected => 'Charge de travail').should be true
    page.has_select?('gain_details_attributes_2_unite', :selected => 'ETP3').should be true
    find_field('gain_details_attributes_2_montants_attributes_2_montant').value.should == '5.0'
    find_field('gain_details_attributes_2_montants_attributes_3_montant').value.should == '6.0'
    page.should have_content('11.0')
  end
  within('tr#4') do
    find_field('gain_details_attributes_3_description').value.should =~ /Description 4/
    page.has_select?('gain_details_attributes_3_nature', :selected => 'Dépenses additionnelles').should be true
    page.has_select?('gain_details_attributes_3_unite', :selected => 'ETP3').should be true
    find_field('gain_details_attributes_3_montants_attributes_3_montant').value.should == '7.0'
    find_field('gain_details_attributes_3_montants_attributes_4_montant').value.should == '8.0'
    page.should have_content('15.0')
  end
  within('tr#5') do
    find_field('gain_details_attributes_4_description').value.should =~ /Description 5/
    page.has_select?('gain_details_attributes_4_nature', :selected => 'Gain trésorerie').should be true
    page.has_select?('gain_details_attributes_4_unite', :selected => 'ETP5').should be true
    find_field('gain_details_attributes_4_montants_attributes_4_montant').value.should == '9.0'
    find_field('gain_details_attributes_4_montants_attributes_5_montant').value.should == '10.0'
    page.should have_content('19.0')
  end
  within('tr#6') do
    find_field('gain_details_attributes_5_description').value.should =~ /Description 6/
    page.has_select?('gain_details_attributes_5_nature', :selected => 'Gain efficacité').should be true
    page.has_select?('gain_details_attributes_5_unite', :selected => 'k€').should be true
    find_field('gain_details_attributes_5_montants_attributes_5_montant').value.should == '1000.0'
    find_field('gain_details_attributes_5_montants_attributes_6_montant').value.should == '2000.0'
    page.should have_content('3 000.0')
  end
  within('tr#7') do
    find_field('gain_details_attributes_6_description').value.should =~ /Description 7/
    page.has_select?('gain_details_attributes_6_nature', :selected => 'Gain productivité').should be true
    page.has_select?('gain_details_attributes_6_unite', :selected => 'k€').should be true
    find_field('gain_details_attributes_6_montants_attributes_6_montant').value.should == '3000.0'
    find_field('gain_details_attributes_6_montants_attributes_7_montant').value.should == '4000.0'
    page.should have_content('7 000.0')
  end
  within('tr#8') do
    find_field('gain_details_attributes_7_description').value.should =~ /Description 8/
    page.has_select?('gain_details_attributes_7_nature', :selected => 'Autres gains').should be true
    page.has_select?('gain_details_attributes_7_unite', :selected => 'k€').should be true
    find_field('gain_details_attributes_7_montants_attributes_7_montant').value.should == '5000.0'
    find_field('gain_details_attributes_7_montants_attributes_8_montant').value.should == '6000.0'
    page.should have_content('11 000.0')
  end
  within('tr#9') do
    find_field('gain_details_attributes_8_description').value.should =~ /Description 9/
    page.has_select?('gain_details_attributes_8_nature', :selected => 'Autres gains').should be true
    page.has_select?('gain_details_attributes_8_unite', :selected => 'ETP1').should be true
    find_field('gain_details_attributes_8_montants_attributes_8_montant').value.should == '11.0'
    find_field('gain_details_attributes_8_montants_attributes_9_montant').value.should == '12.0'
    page.should have_content('23.0')
  end
  page.text.should =~ %r{Coût complet moyen du personnel modèle ETP1 k€/ETP 65\.5 66\.5 73\.7 74\.8 Coût complet moyen du personnel modèle ETP2 \
k€/ETP 65\.4 66\.3 Coût complet moyen du personnel modèle ETP3 k€/ETP 54\.5 55\.3 56\.1 Coût complet moyen du personnel modèle ETP5 k€/ETP 95\.5 \
97\.0 Augmentation des recettes k€ 198\.5 65\.5 133\.0 Economies induites k€ 461\.3 196\.1 265\.2 Charge de travail k€ 604\.3 272\.5 331\.8 \
Dépenses additionnelles k€ 835\.9 387\.1 448\.8 Gain trésorerie k€ 1 829\.5 859\.5 970\.0 Gain efficacité k€ 3 000\.0 1 000\.0 2 000\.0 Gain\
 productivité k€ 7 000\.0 3 000\.0 4 000\.0 Autres gains k€ 12 708\.7 5 000\.0 6 811\.1 897\.6 Total des impacts métier k€ 26 638\.3 65\.5 \
329\.1 537\.7 718\.9 1 308\.3 1 970\.0 5 000\.0 9 000\.0 6 811\.1 897\.6}
end

Quand(/^je saisis un commentaire sur les gains$/) do
    fill_in 'gain_commentaires', :with => 'Un commentaire sur les gains'
end

Alors(/^je vois le commentaire sur les gains$/) do
  page.text.should =~ /Commentaires : Un commentaire sur les gains/
end

Alors(/^je vois la synthèse des gains$/) do
  page.text.should =~ %r{Augmentation des recettes 198\.5 65\.5 133\.0 Economies induites 461\.3 196\.1 265\.2 Charge de travail 604\.3 272\.5 331\.8 \
Dépenses additionnelles 835\.9 387\.1 448\.8 Gain trésorerie 1 829\.5 859\.5 970\.0 Gain efficacité 3 000\.0 1 000\.0 2 000\.0 Gain productivité 7 000\.0 \
3 000\.0 4 000\.0 Autres gains 12 708\.7 5 000\.0 6 811\.1 897\.6 Total des impacts métier 26 638\.3 65\.5 329\.1 537\.7 718\.9 1 308\.3 1 970\.0 5 000\.0 \
9 000\.0 6 811\.1 897\.6 Total Impacts Métiers actualisé 20 654\.0 65\.5 316\.4 497\.1 639\.1 1 118\.3 1 619\.2 3 951\.6 6 839\.3 4 976\.8 630\.6 Total \
des coûts indirects situation actuelle Total des coûts indirects situation cible Total Impacts sur les coûts de fonctionnement des systèmes Total Impacts \
sur les coûts de fonctionnement SI actualisé Gains nets \(Impacts métiers \+ Impacts fonctionnement système\) 26 638\.3 65\.5 329\.1 537\.7 718\.9 1 308\.3 \
1 970\.0 5 000\.0 9 000\.0 6 811\.1 897\.6 TOTAL FLUX ANNUELS non actualisés \(k€\) 26 638\.3 65\.5 329\.1 537\.7 718\.9 1 308\.3 1 970\.0 5 000\.0 \
9 000\.0 6 811\.1 897\.6 TOTAL FLUX ANNUELS actualisés 20 654\.0 65\.5 316\.4 497\.1 639\.1 1 118\.3 1 619\.2 3 951\.6 6 839\.3 4 976\.8 630\.6 TOTAL FLUX \
ANNUELS CUMULES actualisés 65\.5 382\.0 879\.1 1 518\.2 2 636\.5 4 255\.7 8 207\.3 15 046\.6 20 023\.4 20 654\.0 Indicateurs de rentabilité Valeur \
actualisée nette \(VAN\) 20 654\.0 k€ Taux de rendement interne \(TRI\) % Délai de retour 0\.0 ans Coût total du projet 0\.0}
end
