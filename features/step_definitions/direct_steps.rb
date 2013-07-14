# encoding: utf-8

Alors(/^je vois le lien (\d+)$/) do |arg1|
  find_link(arg1).visible?.should be true
end

Alors(/^je vois le lien (.+) dans la zone (.+)$/) do |link,zone|
  within(zone) do
    find_link(link).visible?.should be true
  end
end

Quand(/^dans la zone (.+) je suis le lien (.+)$/) do |zone,link|
  within(zone) do
    click_link(link)
  end
end

Quand(/^dans la zone (.+) je clique sur (.+)$/) do  |zone,bouton|
  within(zone) do click_button(bouton) end
end

Alors(/^je vois le tableau des coûts détaillés$/) do
  page.should have_selector('article#detail')
end

Alors(/^je vois le tableau des coûts cumulés par nature$/) do
  page.should have_selector('article#somme')
end


Quand(/^je remplis le tableau des coûts détaillés$/) do
  within('tr#1') do
    fill_in 'direct_details_attributes_0_description', :with => 'Ligne 1'
    select('Matériel', :from => 'direct_details_attributes_0_nature')
    fill_in 'direct_details_attributes_0_montants_attributes_0_montant', :with => '1000'
    fill_in 'direct_details_attributes_0_montants_attributes_1_montant', :with => '2000'
    fill_in 'direct_details_attributes_0_montants_attributes_3_montant', :with => '1000000'
    click_button('Insv')
  end
  within('tr#2') do
    fill_in 'direct_details_attributes_1_description', :with => 'Ligne 2'
    select('Logiciel', :from => 'direct_details_attributes_1_nature')
    fill_in 'direct_details_attributes_1_montants_attributes_1_montant', :with => '3000'
    fill_in 'direct_details_attributes_1_montants_attributes_2_montant', :with => '4000'
    click_button('Insv')
  end  
  within('tr#3') do
    fill_in 'direct_details_attributes_2_description', :with => 'Ligne 3'
    click_button('Insv')
  end
  within('tr#4') do
    select('Logiciel', :from => 'direct_details_attributes_3_nature')
    click_button('Insv')
    click_button('Insv')
  end
  within('tr#6') do
    fill_in 'direct_details_attributes_5_description', :with => 'Ligne 6'
    select('Matériel', :from => 'direct_details_attributes_5_nature')
    fill_in 'direct_details_attributes_5_montants_attributes_0_montant', :with => '100'
    fill_in 'direct_details_attributes_5_montants_attributes_1_montant', :with => '200'
    fill_in 'direct_details_attributes_5_montants_attributes_2_montant', :with => '300'
    click_button('Insv')
  end
  within('tr#7') do
    fill_in 'direct_details_attributes_6_description', :with => 'Ligne 7'
    select('Autre', :from => 'direct_details_attributes_6_nature')
    fill_in 'direct_details_attributes_6_montants_attributes_2_montant', :with => '25'
    fill_in 'direct_details_attributes_6_montants_attributes_3_montant', :with => '25'
    fill_in 'direct_details_attributes_6_montants_attributes_4_montant', :with => '25'
  end  
end

Alors(/^je vois les cumuls calculés$/) do
  within('tr#1') do
    find_field('direct_details_attributes_0_description').value.should =~ /Ligne 1/
    page.has_select?('direct_details_attributes_0_nature', :selected => 'Matériel').should be true
    find_field('direct_details_attributes_0_montants_attributes_0_montant').value.should == '1000.0'
    find_field('direct_details_attributes_0_montants_attributes_1_montant').value.should == '2000.0'
    find_field('direct_details_attributes_0_montants_attributes_3_montant').value.should == '1000000.0'
    page.should have_content('1 003 000.0')
  end
  within('tr#2') do
    find_field('direct_details_attributes_1_description').value.should =~ /Ligne 2/
    page.has_select?('direct_details_attributes_1_nature', :selected => 'Logiciel').should be true
    find_field('direct_details_attributes_1_montants_attributes_1_montant').value.should == '3000.0'
    find_field('direct_details_attributes_1_montants_attributes_2_montant').value.should == '4000.0'
    page.should have_content('7 000.0')
  end
  within('tr#3') do
    find_field('direct_details_attributes_2_description').value.should =~ /Ligne 6/
    page.has_select?('direct_details_attributes_2_nature', :selected => 'Matériel').should be true
    find_field('direct_details_attributes_2_montants_attributes_0_montant').value.should == '100.0'
    find_field('direct_details_attributes_2_montants_attributes_1_montant').value.should == '200.0'
    find_field('direct_details_attributes_2_montants_attributes_2_montant').value.should == '300.0'
    page.should have_content('600.0')
  end
  within('tr#4') do
    find_field('direct_details_attributes_3_description').value.should =~ /Ligne 7/
    page.has_select?('direct_details_attributes_3_nature', :selected => 'Autre').should be true
    find_field('direct_details_attributes_3_montants_attributes_2_montant').value.should == '25.0'
    find_field('direct_details_attributes_3_montants_attributes_3_montant').value.should == '25.0'
    find_field('direct_details_attributes_3_montants_attributes_4_montant').value.should == '25.0'
    page.should have_content('75.0')
  end
  page.text.should =~ %r{Total des coûts directs 1 010 675\.0 1 100\.0 5 200\.0 4 325\.0 1 000 025\.0 25\.0}
  page.text.should =~ %r{Logiciel 7 000\.0 Matériel 1 003 600\.0 Prestation MOE Prestation MOA Formation Autre 75\.0}
end

Quand(/^je saisis un commentaire sur les coûts directs$/) do
  fill_in 'direct_commentaires', :with => 'Un commentaire sur les coûts directs' 
end

Alors(/^je vois le commentaire sur les coûts directs$/) do
  page.text.should =~ /Un commentaire sur les coûts directs/
end

Alors(/^je vois la synthèse des coûts directs$/) do
  page.text.should =~ %r{Total des coûts directs -1 010 675\.0 -1 100\.0 -5 200\.0 -4 325\.0 -1 000 025\.0 -25\.0 Total des coûts indirects Total Coûts \
d'investissement initial -1 010 675\.0 -1 100\.0 -5 200\.0 -4 325\.0 -1 000 025\.0 -25\.0 Total Coûts d'investissement initial actualisés -899 138\.7 \
-1 100\.0 -5 000\.0 -3 998\.7 -889 018\.6 -21\.4 Total des impacts métier Total Impacts Métiers actualisé Total des coûts indirects situation actuelle \
Total des coûts indirects situation cible Total Impacts sur les coûts de fonctionnement des systèmes Total Impacts sur les coûts de fonctionnement SI \
actualisé Gains nets \(Impacts métiers \+ Impacts fonctionnement système\) TOTAL FLUX ANNUELS non actualisés \(k€\) -1 010 675\.0 -1 100\.0 -5 200\.0 \
-4 325\.0 -1 000 025\.0 -25\.0 TOTAL FLUX ANNUELS actualisés -899 138\.7 -1 100\.0 -5 000\.0 -3 998\.7 -889 018\.6 -21\.4 TOTAL FLUX ANNUELS CUMULES \
actualisés -1 100\.0 -6 100\.0 -10 098\.7 -899 117\.3 -899 138\.7 Indicateurs de rentabilité Valeur actualisée nette \(VAN\) -899 138\.7 k€ Taux de \
rendement interne \(TRI\) % Délai de retour ans Coût total du projet 1 010 675\.0 k€}
end
