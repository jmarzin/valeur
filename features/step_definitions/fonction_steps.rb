# encoding: utf-8

Alors(/^je vois deux tableaux de répartition des cadres d'emplois$/) do
  page.has_css?('table#cadre', :count => 2).should be true
end

Alors(/^je vois deux tableaux des impacts détaillés$/) do
  page.has_css?('table#detail', :count => 2).should be true
end
