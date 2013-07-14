# encoding: utf-8

Quand(/^je saisis un coût direct de 1000 k€ pour la première année$/) do
  within('tr#1') do
    fill_in 'direct_details_attributes_0_description', :with => 'Ligne 1'
    select('Logiciel', :from => 'direct_details_attributes_0_nature')
    fill_in 'direct_details_attributes_0_montants_attributes_0_montant', :with => '1000'
  end
end

Quand(/^je saisis le gain autres de 250 k€ par an sur les 10 années qui suivent$/) do 
  within('tr#1') do
    fill_in 'gain_details_attributes_0_description', :with => 'Description 1'
    select('Autres gains', :from => 'gain_details_attributes_0_nature')
    select('k€', :from => 'gain_details_attributes_0_unite')
    fill_in 'gain_details_attributes_0_montants_attributes_1_montant', :with => '250'
    fill_in 'gain_details_attributes_0_montants_attributes_2_montant', :with => '250'
    fill_in 'gain_details_attributes_0_montants_attributes_3_montant', :with => '250'
    fill_in 'gain_details_attributes_0_montants_attributes_4_montant', :with => '250'
    fill_in 'gain_details_attributes_0_montants_attributes_5_montant', :with => '250'
    fill_in 'gain_details_attributes_0_montants_attributes_6_montant', :with => '250'
    fill_in 'gain_details_attributes_0_montants_attributes_7_montant', :with => '250'
    fill_in 'gain_details_attributes_0_montants_attributes_8_montant', :with => '250'
    fill_in 'gain_details_attributes_0_montants_attributes_9_montant', :with => '250'
    fill_in 'gain_details_attributes_0_montants_attributes_10_montant', :with => '250'
  end
end

Alors(/^je vois les bonnes valeurs pour la VAN, le TRI et le délai de retour$/) do
  page.text.should =~ %r{Total des coûts directs -1 000\.0 -1 000\.0 Total des coûts indirects Total Coûts d'investissement initial -1 000\.0 -1 000\.0 \
Total Coûts d'investissement initial actualisés -1 000\.0 -1 000\.0 Autres gains 2 500\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 \
250\.0 Total des impacts métier 2 500\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 Total Impacts Métiers actualisé 2 027\.7 \
240\.4 231\.1 222\.2 213\.7 205\.5 197\.6 190\.0 182\.7 175\.6 168\.9 Total des coûts indirects situation actuelle Total des coûts indirects situation \
cible Total Impacts sur les coûts de fonctionnement des systèmes Total Impacts sur les coûts de fonctionnement SI actualisé Gains nets \(Impacts métiers \+ \
Impacts fonctionnement système\) 2 500\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 TOTAL FLUX ANNUELS non actualisés \(k€\) \
1 500\.0 -1 000\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 250\.0 TOTAL FLUX ANNUELS actualisés 1 027\.7 -1 000\.0 240\.4 231\.1 \
222\.2 213\.7 205\.5 197\.6 190\.0 182\.7 175\.6 168\.9 TOTAL FLUX ANNUELS CUMULES actualisés -1 000\.0 -759\.6 -528\.5 -306\.2 -92\.5 113\.0 310\.5 500\.5 \
683\.2 858\.8 1 027\.7 Indicateurs de rentabilité Valeur actualisée nette \(VAN\) 1 027\.7 k€ Taux de rendement interne \(TRI\) 21\.4 % Délai de retour \
5\.5 ans Coût total du projet 1 000\.0 k€}
end
