# encoding: utf-8

Etantdonné(/^un projet (.+) et un projet (.+)$/) do |nom1,nom2|
  FactoryGirl.create(:projet, code: '1', nom: nom1)
  FactoryGirl.create(:projet, code: '2', nom: nom2)
end

Etantdonné(/^le projet (.+) dans la base$/) do |nom|
  @projet = FactoryGirl.create(:projet, code: '1', nom: nom,resumes: [FactoryGirl.build(:resume)])
end

Etantdonné(/^que le résume est vide$/) do
  @projet.resumes = []
  visit ('/projets/1/etudes/new')
  @projet.save!
end

Etantdonné(/^le projet (.+) dans la base, résumé vide$/) do |nom|
  @projet = FactoryGirl.create(:projet, code: '1', nom: nom,resumes: [])
end

Etantdonné(/une étude complète sur.+projet (.+)$/) do |nom|
  projet = Projet.find_by(nom: nom)
  @etude = FactoryGirl.create(:etude, projet_id: projet._id,code: 'X',stade: :projet,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 )
  resume = FactoryGirl.build(:resume, etude_id: @etude._id, stade: :projet, cout: 150, duree: 5.4, note: 8.2)
  @etude.projet.resumes.push(resume)
end

Etantdonné(/^une étude complète au stade (.+) non publiée sur le projet Hélios$/) do |stade|
  @etude = FactoryGirl.create(:etude, projet_id: @projet._id, code: 'XXXX',stade: stade.to_sym, publie: false,\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 )
end

Etantdonné(/^que je publie une étude (\d) complète au stade (.+) sur le projet (.+)$/) do |id,stade,projet|
  @etude = FactoryGirl.create(:etude, _id: id,projet_id: @projet._id, code: Lorem.word+rand(10).to_s,stade: stade.to_sym, publie: false,\
    date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 )
  visit "/projets/1/etudes/#{id}/edit"
  check('Publié')
  click_button('Enregistrer')
  page.text.should =~ /L'étude a bien été mise à jour/  
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
  page.text.should =~ /#{@etude._id}\W+X\W+projet\W+Oui\W+2013-01-01\W+2014-01-01\W+3\.0/ #\W+150\.0\W+5\.4\W+8\.2/
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

Quand(/^je saisis (.+) dans la zone (.+)$/) do |valeur,zone|
  fill_in(zone, :with => valeur)
end

Quand(/^le projet a déjà une série d'études dont la dernière est au stade :suivi01$/) do
  @projet.resumes = [] << FactoryGirl.build(:resume, stade: :projet) << FactoryGirl.build(:resume, stade: :suivi01)
  visit '/projets/1/etudes/new'
end

Quand(/^l'étude est au stade bilan$/) do
  FactoryGirl.create(:etude, projet_id: 1,code: 'Y',stade: :bilan,publie: true,date_publication:'2013.01.01',\
    date_debut: '2014.01.01',duree_projet: 3.0,cout: 150.0,delai_retour: 5.4,note: 8.2 )
end

Alors(/^le stade est désactivé$/) do
   expect(page.all('div.field label',:text => 'Stade')[0][:disable]).to eq("true")
end

Quand(/^je ne saisis rien dans le champ (.+)$/) do |champ|
  fill_in(champ, :with => "")  
end

Alors(/^l'étude est ajoutée au résumé du projet$/) do
  @etude.projet.resumes[-1].etude_id.should be @etude._id
end

Alors(/^les dérives sont bien calculées$/) do
  visit '/projets'
  page.text.should =~ /33%\W+100%/
end

Alors(/^je ne peux pas dépublier l'étude (\d)$/) do |num|
  visit "/projets/1/etudes/#{num}/edit"
  expect(find_by_id("etude_publie").disabled?).to eq('disabled')
end

Alors(/^je peux dépublier l'étude (\d)$/) do |num|
  visit "/projets/1/etudes/#{num}/edit"
  expect(find_by_id("etude_publie").disabled?).to_not eq('disabled')    
      @etude.projet.derive_cout.should_not be nil
    @etude.projet.derive_duree.should_not be nil
    uncheck('Publié')
    click_button('Enregistrer')
end


Alors(/^l'étude est retirée du résumé du projet$/) do
  @etude =  Etude.find(@etude._id)
  (@etude.projet.resumes.empty? || (@etude.projet.resumes[-1].etude_id != @etude._id)).should be true
end

Alors(/^les dérives sont bien recalculées$/) do
  @etude.projet.derive_cout.should be nil
  @etude.projet.derive_duree.should be nil
end

Alors(/^tous les champs sont inaccessibles, sauf publié$/) do
  expect(find_by_id("etude_code").disabled?).to eq("disabled")
  expect(find_by_id("etude_description").disabled?).to eq("disabled")
  expect(find_by_id("etude_date_debut_1i").disabled?).to eq("disabled")
  expect(find_by_id("etude_duree_projet").disabled?).to eq("disabled")
#  expect(find_by_id("etude_type_produit").disabled?).to eq("disabled")
  expect(find_by_id("etude_duree_vie").disabled?).to eq("disabled")
  expect(find_by_id("etude_publie").disabled?).to_not eq("disabled")
  expect(find_by_id("etude_date_publication_1i").disabled?).to eq("disabled")
  expect(find_by_id("etude_cout").disabled?).to eq("disabled")
  expect(find_by_id("etude_delai_retour").disabled?).to eq("disabled")
  expect(find_by_id("etude_note").disabled?).to eq("disabled")
end

Alors(/^le lien (.+) est absent sur la ligne de la première$/) do |zone|
  reg = Regexp.new(zone)
  page.all('tr',:text => 'projet').first.text.should_not =~ reg
end
Alors(/^le lien (.+) est présent sur la ligne de la première$/) do |zone|
  reg = Regexp.new(zone)
  page.all('tr',:text => 'projet').first.text.should =~ reg
end

Alors(/^le lien Modif est absent$/) do
  page.text.should_not =~ /Modif/
end

Alors(/^j'ai créé une copie de l'étude 1$/) do
  @etude1 = Etude.find("1")
  @etude2 = Etude.find("2")
  @etude1.fields.each_key do |nom|
    case nom
    when "_id", "code"
      @etude1[nom].should_not == @etude2[nom]
    else
      @etude1[nom].should == @etude2[nom]
    end
  end
  @enfants1 = @etude1._children
  @enfants2 = @etude2._children
  @enfants1.count.should == @enfants2.count
  @enfants1.each_index do |i|
    @enfants1[i].class.should == @enfants2[i].class
    @enfants1[i].fields.each_key do |nom|
      if nom == "_id" then
        @enfants1[i][nom].should_not == @enfants2[i][nom]
      else
        @enfants1[i][nom].should == @enfants2[i][nom]
      end
    end
  end
end
