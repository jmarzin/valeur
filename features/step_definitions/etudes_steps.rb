# encoding: utf-8

Etantdonné(/^un projet (.+) et un projet (.+)$/) do |nom1,nom2|
  FactoryGirl.create(:projet, code: '1', nom: nom1)
  FactoryGirl.create(:projet, code: '2', nom: nom2)
end

Etantdonné(/^une étude sur le seul projet (.+)$/) do |nom|
  projet = Projet.find_by(nom: nom)
  etude = FactoryGirl.create(:etude, projet_id: projet._id)
end

Quand(/^je clique le lien Etudes de la ligne Hélios$/) do
  within('tr', :text => 'Hélios') do |ref|
    click_link("Etudes")
  end
end  

Alors(/^je vois (.+)$/) do |texte|
  page.text.should =~ Regexp.new(texte)
end

