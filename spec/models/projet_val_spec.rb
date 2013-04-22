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
  it { should have_fields(:date_etude_lancement) }
  it { should have_fields(:cout_etude_lancement) }
  it { should have_fields(:dr_etude_lancement) }
  it { should have_fields(:date_derniere_etude) }
  it { should have_fields(:cout_derniere_etude) }
  it { should have_fields(:dr_derniere_etude) }
  it { should have_fields(:derive_cout) }
  it { should have_fields(:derive_dr) }
  it "Si le statut est lancé, ou terminé, ou arrêté, :date_, cout_ et dr_etude_lancement sont présents" do
    FactoryGirl.build(:projet, :etat => :lance, :date_etude_lancement => nil,
	:cout_etude_lancement => nil, :dr_etude_lancement => nil).should be_invalid
    FactoryGirl.build(:projet, :etat => :lance, :date_etude_lancement => '01.01.2013',
	:cout_etude_lancement => nil, :dr_etude_lancement => nil).should be_invalid
    FactoryGirl.build(:projet, :etat => :lance, :date_etude_lancement => '01.01.2013',
	:cout_etude_lancement => 1000000.00, :dr_etude_lancement => nil).should be_invalid
    FactoryGirl.build(:projet, :etat => :arrete, :date_etude_lancement => '01.01.2013',
	:cout_etude_lancement => 1000000.00, :dr_etude_lancement => nil).should be_invalid
  end
  it "Si le statut n'est ni lancé, ni terminé, ni arrêté, :date_, cout_ et dr_etude_lancement sont absents" do
    pending "A développer"
  end
  it "Si la date_etude_lancement n'est pas fournie, date_, cout_ et dr_derniere_etude sont absents" do
    pending "A développer"
  end
  it "Les date_, cout_ et dr_derniere_etude, sont soit toutes absentes, soit toutes présentes" do
    pending "A développer"
  end
  it "Si la date_derniere_etude est fournie, alors la derive cout et dr sont présents" do
    pending "A développer"
  end
end
