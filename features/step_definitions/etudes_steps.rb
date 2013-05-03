# encoding: utf-8

Etantdonné(/^un projet (.+) et un projet (.+)$/) do |nom1,nom2|
  FactoryGirl.create(:projet, code: '1', nom: nom1)
  FactoryGirl.create(:projet, code: '2', nom: nom2)
end

Etantdonné(/^le projet (.+) dans la base$/) do |nom|
  @projet = FactoryGirl.create(:projet, code: '1', nom: nom,resumes: [FactoryGirl.build(:resume)])
end

Etantdonné(/une étude complète sur.+projet (.+)$/) do |nom|
  projet = Projet.find_by(nom: nom)
  @etude = FactoryGirl.create(:etude, projet_id: projet._id,code: 'X',stade: :projet,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 4.5,type_produit: :front_office,duree_vie: 5,cout: 500.10,delai_retour: 5.4,note: 8.2 )
end

Etantdonné(/^une étude complète au stade (.+) non publiée sur le projet Hélios$/) do |bilan|
  @etude = FactoryGirl.create(:etude, projet_id: @projet._id, code: 'XXXX',stade: bilan.to_sym, publie: false,\
    date_debut: '2014.01.01',duree_projet: 4.5,type_produit: :front_office,duree_vie: 5,cout: 500.10,delai_retour: 5.4,note: 8.2 )
end
Quand(/^je clique le lien Etudes de la ligne Hélios$/) do
  within('tr', :text => 'Hélios') do |ref|
    click_link("Etudes")
  end
end  

Alors(/^je vois le texte (.+)$/) do |texte|
  page.text.should =~ Regexp.new(texte)
end

Quand(/^il n'y a pas d'étude sur le projet (.+)$/) do |nom|
  projet = Projet.find_by(nom: "Chorus")
  projet.etudes.count.should be 0
end

Quand(/^je suis sur la page des études du projet$/) do
  visit "/projets/1/etudes"
end

Alors(/^je ne vois pas la ligne d'entête$/) do
  page.text.should_not =~ /Code/
end

Alors(/^je vois la ligne Id,Code,Stade,Publié,Le,Date début,Durée,Coût,Retour,Note$/) do
  page.text.should =~ /Id\W+Code\W+Stade\W+Publié\W+Le\W+Date début\W+Durée\W+Coût\W+Retour\W+Note/
end

Alors(/^je vois ses Id,Code,Stade,Publié,Le,Date début,Durée,Coût,Retour,Note$/) do
  page.text.should =~ /#{@etude._id}\W+X\W+projet\W+Oui\W+2013-01-01\W+2014-01-01\W+4\.5/ #\W+500\.0\W+5\.4\W+8\.2/
end

Etantdonné(/^que je saisis les données du formulaire étude$/) do
  fill_in('etude_code', :with => "XXXX")
  select('projet', :from => 'etude_stade')
  fill_in('etude_description', :with => "Scénario de base")
  fill_in('etude_duree_projet', :with => "4.5")
  select('back_office', :from => 'etude_type_produit')
  fill_in('etude_duree_vie', :with => 4)
end

Alors(/^je vois le stade (.+)$/) do |stade|
  page.has_select?('Stade', :with_options => [stade]).should be true
end

Alors(/^l'étude est créée$/) do
  page.text.should =~ /L'étude a été créée/
end

Quand(/^je saisis (\d+) dans la zone (.+)$/) do |valeur,zone|
  fill_in(zone, :with => valeur)
end

Quand(/^le projet a déjà une série d'études dont la dernière est au stade :suivi01$/) do
  @projet.resumes = [] << FactoryGirl.build(:resume, stade: :projet) << FactoryGirl.build(:resume, stade: :suivi01)
  visit '/projets/1/etudes/new'
end

Quand(/^l'étude est au stade bilan$/) do
  FactoryGirl.create(:etude, projet_id: 1,code: 'Y',stade: :bilan,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 4.5,cout: 500.10,delai_retour: 5.4,note: 8.2 )
end

Alors(/^le stade est désactivé$/) do
  select('bilan', :from => 'Stade').should raise_error
end

Quand(/^je ne saisis rien dans le champ (.+)$/) do |champ|
  fill_in(champ, :with => "")  
end

Alors(/^l'étude est ajoutée au résumé du projet$/) do
  @etude.projet.resumes[-1].etude_id.should be @etude._id
end
