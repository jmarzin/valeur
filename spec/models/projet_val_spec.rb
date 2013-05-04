# encoding: utf-8
require 'spec_helper'


describe Projet do
  it { should have_field(:code) }
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code) }
  it { should have_field(:nom) }
  it { should validate_presence_of(:nom) }
  it { should have_field(:ministere) }
  it { should validate_presence_of(:ministere) }
  it { should have_field(:public) }
  it { should validate_presence_of(:public) }
  it { should have_field(:etat) } # les valeurs prises sont pilotées par le workflow
  it { should have_field(:description) }
  it { should validate_presence_of(:description) }
  it { should have_field(:entites_concernees) }
  it { should validate_presence_of(:entites_concernees) }
  it { should have_field(:date_debut) }
  it { should validate_presence_of(:date_debut) }
  it { should embed_many(:resumes) }
  it { should have_many(:etudes) }
  before(:each) { @resume1 = FactoryGirl.build(:resume, stade: :projet, date: '01.01.2013', cout: 100000, duree: 4.5) }
  it "Si le statut est lancé, ou terminé, ou arrêté, il y a ou moins un résumé" do
    FactoryGirl.build(:projet, etat: :en_cours, date_debut: '2013.01.01', resumes: []).should be_invalid
    FactoryGirl.build(:projet, etat: :en_cours, date_debut: '2013.01.01', resumes: [@resume1]).should be_valid
  end
  it { should have_field(:derive_cout) }
  it "Pas de dérive des coûts s'il n'y a qu'une étude" do
    FactoryGirl.build(:projet,etat: :en_cours, resumes: [@resume1], derive_cout: 50).should be_invalid
    FactoryGirl.build(:projet,etat: :en_cours, resumes: [], derive_cout: 50).should be_invalid
  end
  it { should have_field(:derive_duree) }
  it "Pas de dérive du délai s'il n'y a qu'une étude" do
    FactoryGirl.build(:projet,etat: :en_cours, resumes: [@resume1], derive_cout: 50, derive_duree: 10).should be_invalid
    FactoryGirl.build(:projet,etat: :en_cours, resumes: [], derive_cout: 50, derive_duree: 10).should be_invalid
  end
  before(:each) { @resume2 = FactoryGirl.build(:resume, stade: :suivi01, date: '01.01.2013', cout: 100000, duree: 4.5) }
  it "Chaque résumé doit être complet" do
    FactoryGirl.build(:projet,etat: :en_cours, date_debut: '2013.01.01', resumes: [@resume1,@resume2], derive_cout: 0, derive_duree: 0).should be_valid
    @resume2.cout = nil
    FactoryGirl.build(:projet,etat: :en_cours, date_debut: '2013.01.01', resumes: [@resume1,@resume2], derive_cout: 0, derive_duree: 0).should be_invalid
  end
  it "S'il y a plusieurs études, la dérive des coûts est servie" do
    FactoryGirl.build(:projet,etat: :en_cours, resumes: [@resume1,@resume2], derive_cout: nil, derive_duree: 10).should be_invalid
  end
  it "S'il y a plusieurs études, la dérive du délai est servie" do
    FactoryGirl.build(:projet,etat: :en_cours, resumes: [@resume1,@resume2], derive_cout: 50, derive_duree: nil).should be_invalid
  end
  it { should have_field(:quotation_disic) }
  it { should validate_inclusion_of(:quotation_disic).to_allow([0,1,2,3,4,5]) }
  it "L'identifiant est calculé en incrémentant le plus grand identifiant de la base" do
    3.times do |i|
      if Projet.count == 0 then plus_grand = 0 else plus_grand = Projet.last._id end
      FactoryGirl.create(:projet,code: i.to_s)._id.should be == plus_grand + 1
    end
  end
end
