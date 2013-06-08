# encoding: utf-8

Alors(/^je vois le tableau de répartition des cadres d'emplois$/) do
  page.should have_selector('article#cadre')
end
