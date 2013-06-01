# encoding: utf-8

Alors(/^je vois la question (.+)$/) do |question|
  page.should have_content question
end

Quand(/^je suis le premier lien Modif$/) do
  page.all('a')[0].click
end

Quand(/^je sélectionne les valeurs:$/) do |table|
  # table is a Cucumber::Ast::Table
  @tableau = table.raw
  @tableau.each_index do |i| page.all('select')[i].select(@tableau[i][0]) end
end

Quand(/^je clique le premier bouton Enregistrer$/) do
  page.all('input')[3].click
end

Alors(/^je vois les bons résultats calculés$/) do
  page.text.should =~ %r{14\.0\/20.+12\.9\/20.+12\.1\/20.+13\.3\/20.+moyen.+20\.0\/20.+forts.+6\.7\/20.+faible.+8\.3\/20.+nulle.+
                         13\.3\/20.+13\.3\/20.+moyen.+13\.3\/20.+moyen.+15\.6\/20.+fort.+6\.7\/20.+faible.+16\.7\/20.+fort.+
                         15\.0\/20.+B.+20\.0\/20.+fort.+7\.3\/20.+faible.+17\.6\/20.+fort}x
end

Alors(/^je vois qu'il manque des résultats$/) do
  page.text.should =~ %r{\s \/20.+12\.9\/20.+12\.1\/20.+13\.3\/20.+moyen.+20\.0\/20.+forts.+6\.7\/20.+faible.+8\.3\/20.+nulle.+
                         13\.3\/20.+13\.3\/20.+moyen.+13\.3\/20.+moyen.+15\.6\/20.+fort.+6\.7\/20.+faible.+16\.7\/20.+fort.+
                         \s\/20.+20\.0\/20.+fort.+7\.3\/20.+faible.+\s\/20.}x
end
