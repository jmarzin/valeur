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
