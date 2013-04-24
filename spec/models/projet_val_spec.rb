# encoding: utf-8
require 'spec_helper'


describe Projet do
  it { should have_fields(:code) }
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code) }
  it { should have_fields(:nom) }
  it { should validate_presence_of(:nom) }
  it { should have_fields(:ministere) }
  it { should have_fields(:public) }
  it { should validate_presence_of(:public) }
  it { should have_fields(:etat) } # les valeurs prises sont pilotées par le workflow
  it { should have_fields(:description) }
  it { should validate_presence_of(:description) }
  it { should have_fields(:entites_concernees) }
  it { should validate_presence_of(:entites_concernees) }
  it { should have_fields(:date_debut) }
  it { should validate_presence_of(:date_debut) }
  it { should have_fields(:type_de_produit) }
  it { should validate_inclusion_of(:type_de_produit).to_allow([:front_office, :back_office, :valeur]) }
  it { should have_fields(:duree_de_vie) }
  it { should validate_presence_of(:duree_de_vie)}
  it { should embed_many(:resumes) }
  before(:each) { @resume1 = FactoryGirl.build(:resume, date: '01.01.2013', cout: 100000, dr: 4.5) }
  it "Si le statut est lancé, ou terminé, ou arrêté, il y a ou moins un résumé" do
    FactoryGirl.build(:projet, etat: :lance, resumes: []).should be_invalid
    FactoryGirl.build(:projet, etat: :lance, resumes: [@resume1]).should be_valid
  end
  it { should have_fields(:derive_cout) }
  it "Pas de dérive des coûts s'il n'y a qu'une étude" do
    FactoryGirl.build(:projet,etat: :lance, resumes: [@resume1], derive_cout: 50).should be_invalid
    FactoryGirl.build(:projet,etat: :lance, resumes: [], derive_cout: 50).should be_invalid
  end
  it { should have_fields(:derive_dr) }
  it "Pas de dérive du délai de retour s'il n'y a qu'une étude" do
    FactoryGirl.build(:projet,etat: :lance, resumes: [@resume1], derive_cout: 50, derive_dr: 10).should be_invalid
    FactoryGirl.build(:projet,etat: :lance, resumes: [], derive_cout: 50, derive_dr: 10).should be_invalid
  end
  before(:each) { @resume2 = FactoryGirl.build(:resume, date: '01.01.2013', cout: 100000, dr: 4.5) }
  it "Chaque résumé doit être complet" do
    FactoryGirl.build(:projet,etat: :lance, resumes: [@resume1,@resume2], derive_cout: 0, derive_dr: 0).should be_valid
    @resume2.cout = nil
    FactoryGirl.build(:projet,etat: :lance, resumes: [@resume1,@resume2], derive_cout: 0, derive_dr: 0).should be_invalid
  end
  it "S'il y a plusieurs études, la dérive des coûts est servie" do
    FactoryGirl.build(:projet,etat: :lance, resumes: [@resume1,@resume2], derive_cout: nil, derive_dr: 10).should be_invalid
  end
  it "S'il y a plusieurs études, la dérive du délai de retour est servie" do
    FactoryGirl.build(:projet,etat: :lance, resumes: [@resume1,@resume2], derive_cout: 50, derive_dr: nil).should be_invalid
  end
  it { should have_fields(:quotation_disic) }
  it { should validate_inclusion_of(:quotation_disic).to_allow([0,1,2,3,4,5]) }
end
