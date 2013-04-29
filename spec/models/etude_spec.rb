# -*- coding: utf-8 -*-
require 'spec_helper'

describe Etude do
  it { should belong_to(:projet) }

  it "L'identifiant est calculé en incrémentant le plus grand identifiant de la base" do
    3.times do |i|
      if Projet.count == 0 then plus_grand = 0 else plus_grand = Projet.last._id end
      FactoryGirl.create(:projet,code: i.to_s)._id.should be == plus_grand + 1
      pending "A vérifier"
    end
  end
  it { should have_field(:stade) }
  it { should validate_presence_of(:stade) }
  it "ne peut avoir que avant_projet, projet, suivinn ou bilan comme stade" do pending end
  it { should have_field(:code) }
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code).scoped_to(:projet_id) }
  it { should have_field(:description) }
  it { should validate_presence_of(:description) }
  it { should have_field(:date_debut) }
  it { should validate_presence_of(:date_debut) }
  it { should have_field(:duree_projet) }
  it { should validate_presence_of(:duree_projet) }
  it { should have_field(:type_produit) }
  it { should validate_presence_of(:type_produit) }
  it { should validate_inclusion_of(:type_produit) }
  it { should have_field(:duree_vie) }
  it { should validate_presence_of(:duree_vie) }
  it { should have_field(:publie) }
  it { should have_field(:date_publication) }
  it "a une date si elle est publiée" do pending end
  it "n'a pas de date si elle n'est pas publiée" do pending end
  it "n'a qu'une publication pour chaque stade" do
    projet = FactoryGirl.create(:projet)
    p projet.class
    expect{ FactoryGirl.create(:etude, code: '1', projet_id: projet._id, stade: "projet", publie: true)}.to_not raise_error(Mongoid::Errors::Validations) 
    expect{ FactoryGirl.create(:etude, code: '2', projet_id: projet._id, stade: "projet", publie: true)}.to raise_error(Mongoid::Errors::Validations,"Doublon de publication")
  end
  it { should have_field(:note) }
  it { should have_field(:cout) }
  it { should have_field(:delai_retour) }
  it { should embed_one :etude_strategie }
  it { should embed_one :etude_rentabilite }

end
