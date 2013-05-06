# encoding: utf-8
require 'spec_helper'

describe Projet do
  describe " Etablissement de la liste des stades possibles pour une étude en modification" do
    before(:each) do
      @projet = FactoryGirl.create(:projet, code: '1', nom: 'Chorus',resumes: [])
      @etude = FactoryGirl.create(:etude, projet_id: @projet._id, code: 'XXXX',stade: :avant_projet, publie: false,\
        date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 )
      @curseur = double()
      Etude.stub(:where).and_return(@curseur)
    end
    it "S'il n'y a aucune étude dans la base, la liste des stades est complète" do
      @curseur.stub(:last).and_return(nil)
      @etude.liste_stades.should eq([:avant_projet,:projet,:suivi01,:bilan])
    end
    it "Si la dernière étude est un avant_projet publié, la liste des stades commence avec projet" do
      @curseur.stub(:last).and_return(FactoryGirl.build(:etude, publie: true, stade: :avant_projet))
      @etude.liste_stades.should eq([:projet,:suivi01,:bilan])
    end
    it "Si la dernière étude est un projet publié, la liste des stades commence avec suivi01" do
      @curseur.stub(:last).and_return(FactoryGirl.build(:etude, publie: true, stade: :projet))
      @etude.liste_stades.should eq([:suivi01,:bilan])
    end
    it "Si la dernière étude est un suivi01 publié, la liste des stades commence avec suivi02" do
      @curseur.stub(:last).and_return(FactoryGirl.build(:etude, publie: true, stade: :suivi01))
      @etude.liste_stades.should eq([:suivi02,:bilan])
    end
    it "Si la dernière étude est un bilan publié, la liste des stades commence avec bilan" do
      @curseur.stub(:last).and_return(FactoryGirl.build(:etude, publie: true, stade: :bilan))
      @etude.liste_stades.should eq([:bilan])
    end
    it "Si la dernière étude est un avant_projet non publié, la liste des stades commence avec avant-projet" do
      @curseur.stub(:last).and_return(FactoryGirl.build(:etude, publie: false, stade: :avant_projet))
      @etude.liste_stades.should eq([:avant_projet,:projet,:suivi01,:bilan])
    end
    it "Si la dernière étude est un projet non publié, la liste des stades commence avec projet" do
      @curseur.stub(:last).and_return(FactoryGirl.build(:etude, publie: false, stade: :projet))
      @etude.liste_stades.should eq([:projet,:suivi01,:bilan])
    end
    it "Si la dernière étude est un suivi01 non publié, la liste des stades commence avec suivi01" do
      @curseur.stub(:last).and_return(FactoryGirl.build(:etude, publie: false, stade: :suivi01))
      @etude.liste_stades.should eq([:suivi01,:bilan])
    end
    it "Si la dernière étude est un suivi02 non publié, la liste des stades commence avec suivi01" do
      @curseur.stub(:last).and_return(FactoryGirl.build(:etude, publie: false, stade: :suivi02))
      @etude.liste_stades.should eq([:suivi02,:bilan])
    end
    it "Si la dernière étude est un bilan non publié, la liste des stades commence avec bilan" do
      @curseur.stub(:last).and_return(FactoryGirl.build(:etude, publie: false, stade: :bilan))
      @etude.liste_stades.should eq([:bilan])
    end
  end
end
