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
  page.should have_selector('article.direct_detail')
end

Alors(/^je vois le tableau des coûts cumulés par nature$/) do
  page.should have_selector('article.direct_somme')
end

Quand(/^je remplis le tableau des coûts détaillés$/) do
  within('tr#1') do
    fill_in 'direct_details_attributes_0_description', :with => 'Ligne 1'
    select('Matériel', :from => 'direct_details_attributes_0_nature')
    fill_in 'direct_details_attributes_0_montants_attributes_0_montant', :with => '1000'
    fill_in 'direct_details_attributes_0_montants_attributes_1_montant', :with => '2000'
    fill_in 'direct_details_attributes_0_montants_attributes_3_montant', :with => '1000000'
  end
  within('tr#2') do
    fill_in 'direct_details_attributes_1_description', :with => 'Ligne 2'
    select('Logiciel', :from => 'direct_details_attributes_1_nature')
    fill_in 'direct_details_attributes_1_montants_attributes_1_montant', :with => '3000'
    fill_in 'direct_details_attributes_1_montants_attributes_2_montant', :with => '4000'
  end  
  within('tr#3') do
    fill_in 'direct_details_attributes_2_description', :with => 'Ligne 3'
  end
  within('tr#4') do
    select('Logiciel', :from => 'direct_details_attributes_3_nature')
  end
  within('tr#6') do
    fill_in 'direct_details_attributes_5_description', :with => 'Ligne 6'
    select('Matériel', :from => 'direct_details_attributes_5_nature')
    fill_in 'direct_details_attributes_5_montants_attributes_0_montant', :with => '100'
    fill_in 'direct_details_attributes_5_montants_attributes_1_montant', :with => '200'
    fill_in 'direct_details_attributes_5_montants_attributes_2_montant', :with => '300'
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
    find_field('direct_details_attributes_0_description').value.should == 'Ligne 1'
    page.has_select?('direct_details_attributes_0_nature', :selected => 'Matériel').should be true
    find_field('direct_details_attributes_0_montants_attributes_0_montant').value.should == '1000'
    find_field('direct_details_attributes_0_montants_attributes_1_montant').value.should == '2000'
    find_field('direct_details_attributes_0_montants_attributes_3_montant').value.should == '1000000'
    page.should have_content('1 003 000')
  end
  within('tr#2') do
    find_field('direct_details_attributes_1_description').value.should == 'Ligne 2'
    page.has_select?('direct_details_attributes_1_nature', :selected => 'Logiciel').should be true
    find_field('direct_details_attributes_1_montants_attributes_1_montant').value.should == '3000'
    find_field('direct_details_attributes_1_montants_attributes_2_montant').value.should == '4000'
    page.should have_content('7 000')
  end
  within('tr#3') do
    find_field('direct_details_attributes_2_description').value.should == 'Ligne 6'
    page.has_select?('direct_details_attributes_2_nature', :selected => 'Matériel').should be true
    find_field('direct_details_attributes_2_montants_attributes_0_montant').value.should == '100'
    find_field('direct_details_attributes_2_montants_attributes_1_montant').value.should == '200'
    find_field('direct_details_attributes_2_montants_attributes_2_montant').value.should == '300'
    page.should have_content('600')
  end
  within('tr#4') do
    find_field('direct_details_attributes_3_description').value.should == 'Ligne 7'
    page.has_select?('direct_details_attributes_3_nature', :selected => 'Autre').should be true
    find_field('direct_details_attributes_3_montants_attributes_2_montant').value.should == '25'
    find_field('direct_details_attributes_3_montants_attributes_3_montant').value.should == '25'
    find_field('direct_details_attributes_3_montants_attributes_4_montant').value.should == '25'
    page.should have_content('75')
  end
  page.text.should =~ /Totaux \(k€\) 1 010 675 1 100 5 200 4 325 1 000 025 25/
  page.text.should =~ /Logiciel 7 000 Matériel 1 003 600 Prestation MOE Prestation MOA Formation Autre 75/
end

Quand(/^je saisis un commentaire pour le matériel$/) do
  fill_in 'direct_sommes_attributes_1_commentaire', :with => 'Un commentaire sur le matériel' 
end

Alors(/^je vois le commentaire au bon endroit$/) do
  page.text.should =~ /Matériel 1 003 600 Un commentaire sur le matériel/
end
